require 'rubygems' 
require 'em-websocket'

EventMachine.run { 
  @channels = Hash.new {|h,k| h[k] = EM::Channel.new } 
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8000, :debug => true) do |
  ws|
    
    ws.onopen do 
      sid = nil 
      fiveboard_channel = nil

    ws.onmessage do |msg| 
      command, value = msg.split(":", 2); 
      case command
        when 'registra' 
          fiveboard_channel = @channels[value] 
          sid = fiveboard_channel.subscribe { |txt| ws.send(txt) }
		  puts "registrato"
        when 'aggiorna' 
          fiveboard_channel.push('comando:' + value)
      end 
    end

    ws.onclose do 
      fiveboard_channel.unsubscribe(sid)
    end 
  end
end 
puts "ok"
}