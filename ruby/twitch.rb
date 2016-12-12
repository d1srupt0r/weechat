def weechat_init
  Weechat.register("Twitch", "Twitch", "1.0", "GPL3", "Twitch features and colors", "", "")
  Weechat.print("", "Let's get it on with the gaming!")

  Weechat.hook_modifier("irc_in_privmsg", "modifier_cb", "")

  return Weechat::WEECHAT_RC_OK
end

def modifier_cb data, modifier, modifier_data, string
  # split message hash and get buffer based on channel and server
  msg = Weechat.info_get_hashtable("irc_message_parse", "message" => string)
  buffer = Weechat.info_get("irc_buffer", "#{modifier_data},#{msg['channel']}")
  # split message on semicolon and get tags based on equation operator
  tags = Hash[msg["tags"].split(";").map { |t| t.split("=", 2) }]  
  color = tags["color"]

  Weechat.print("", "#{tags}")
  #Weechat.print("", "#{color} #{tags["display-name"]}")

  # display original text in all it's glory
  return "#{string}"
end

