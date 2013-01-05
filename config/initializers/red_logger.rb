#
# ActiveSupport patches
#
# DM TODO need to make this only development
module ActiveSupport

  # Format the buffered logger with timestamp/severity info.
  class BufferedLogger
    def red(message = nil, progname = nil, &block)
      # http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
      message = "\e[1;31m #{message}\e[0m"

      @log.add(Severity::DEBUG, message, progname, &block)

      #message
    end
  end

end
