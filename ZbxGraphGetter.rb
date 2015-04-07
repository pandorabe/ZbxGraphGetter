# coding: utf-8
require 'rubygems'
require 'open-uri'
require 'net/http'
require 'json'

class ZbxGraphGetter
 
  def http_request(body)
    url = URI.parse(APIPAGE)
    req = Net::HTTP::Post.new(url.path, initheader = { 'Content-Type' => 'application/json' })
    req.body = body
    resp = Net::HTTP::start(url.host, url.port) do |http|
      http.request(req)
    end
    if JSON.parse(resp.body)['error']
      puts JSON.parse(resp.body)['error']['data']
      exit(0)
    elsif @auth ||= JSON.parse(resp.body)['result']
    end
    @body = resp.body
  end
  
  def auth_json
    if ZBXVER >= 2.0
      {
        'jsonrpc' => '2.0',
        'method' => 'user.login',
        'params' => {
          :user => USER,
          :password => PASSWORD,
        },
        'id' => 1
      }.to_json
    else ZBXVER == 1.8
      {
        'jsonrpc' => '2.0',
        'method' => 'user.login',
        'params' => {
          :user => USER,
          :password => PASSWORD,
        },
        'auth' => 'null',
        'id' => 1
      }.to_json
    end
  end
  
  def host_json
    {
      'jsonrpc' => '2.0',
      'method' => 'host.get',
      'params' => {
        'output' => ['hostid', 'host'],
      },
      'auth' => @auth,
      'id' => 1
    }.to_json
  end
  
  def graph_json(hostname)
    {
      'jsonrpc' => '2.0',
      'method' => 'graph.get',
      'params' => {
        'filter' => {'host' => hostname},
        'selectGraphs' => ['graphid'],
        'output' =>  'extend',
      },
      'auth' => @auth,
      'id' => 1
    }.to_json
  end

  def dict_get(targetid, targetname)
    body=JSON.parse(@body)
    @id = []
    @dict = Hash.new
    num = 0
  
    unless body['error']
      body['result'].each do |d|
        num = d[targetid]
        name = d[targetname]
        @dict[name] = num
          unless num.nil?
            @id.push(@dict[name])
          end
      end
    else
      puts body['error']['data']
      puts "code = " + body['error']['code'].to_s
      puts "message = " + body['error']['message']
    end
  end

  def hostlist_gen
    h = dict_get('hostid', 'host')
    File.open(FNAME + '_hostlist.txt','a') do |f|
      h.each do |i|
        f.write i['host'] + "\n"
      end
    end
  end
  
  def graph_path(*params)
    url = "http://#{HOST}/zabbix/chart2.php?"
    open(url + URI.encode(params.join('&')), 'Cookie' => "zbx_sessionid=#{@auth}")
  end
    
  def png_getter
    File.foreach(FNAME + '_hostlist.txt') do |frd|
      http_request(graph_json(frd.chomp))
      dict_get('graphid', 'name')
        @id.each do |i|
          File.open(frd.chomp + '_' + i.to_s + '.png', 'wb') do |f|
            f.write graph_path(
              "groupid=0",
              "hostid=#{frd}.chomp",
              "graphid=#{i}",
              "width=#{WD}",
              "height=#{HG}",
              "period=#{PD}",
              "stime=#{ST}"
            ).read
          end
        end
    end
  end
end
