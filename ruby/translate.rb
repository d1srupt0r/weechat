require "uri"

### NOTE: This requires translate-shell

def weechat_init
  Weechat.register("Translate", "Translate", "1.0", "GPL3", "Translate chat input", "", "")
  Weechat.print("", "Time to translate!")

  Weechat.hook_modifier("irc_in_privmsg", "modifier_cb", "")

  return Weechat::WEECHAT_RC_OK
end

def modifier_cb data, modifier, modifier_data, string
  # split message hash and get buffer based on channel and server
  msg = Weechat.info_get_hashtable("irc_message_parse", "message" => string)
  buffer = Weechat.info_get("irc_buffer", "#{modifier_data},#{msg['channel']}")

  # remove bad characters
  msg["text"].gsub! URI.regexp, ""
  msg["text"].gsub! "[!@#$%^&*?()<>{}/\]" ""
  Weechat.print("", "#{msg["text"]}")

  result = %x(trans -id "#{msg["text"]}").include? "English"
  Weechat.print(buffer, "#{Weechat.color("yellow,blue")}#{result}")

  # check for english
  is_en = %x(trans -id "#{msg["text"]}").include? "English" 
  if !is_en
    # only show text if different than original
    en = %x(trans -b "#{msg["text"]}")
	
    if en.strip! != msg["text"]
      Weechat.print(buffer, "#{Weechat.color("yellow,blue")}#{en}")
    end
  end

  # display original text in all it's glory
  return "#{string}"
end

