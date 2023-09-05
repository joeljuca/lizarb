class Liza::PanelRescuerPart < Liza::Part
  insertion do

    #

    def rescue_from(*args, with: nil, &block)
      rescuer = Rescuer.new

      raise ArgumentError, "either with: or block is required, but not both" if with && block

      case args.count
      when 1

        e_class = args[0]
        e_class = _rescue_from_parse_symbol(e_class) if Symbol === e_class

      when 2
        
        e_class = args[0]
        e_class = _rescue_from_parse_symbols(args) if Symbol === e_class
      
      else
      
        raise ArgumentError, "wrong number of arguments (given #{args.count}, expected 1..2)"
      
      end

      unless e_class
        msg = "args #{args} parsed to #{e_class} (expected a descendant of Exception)"
        raise ArgumentError, msg
      end

      e_class_is_exception = e_class.ancestors.include? Exception
      unless e_class_is_exception
        msg = "args #{args} parsed to #{e_class} (expected a descendant of Exception)"
        raise ArgumentError, msg
      end

      rescuer[:exception_class] = e_class
      rescuer[:with] = with
      rescuer[:block] = block

      if with.nil? && block.nil?
        puts "rescue_from #{e_class} with: or block: is required".red
        raise ArgumentError, "with: or block: is required", caller
      end

      rescuers.push(rescuer)
    end

    def _rescue_from_parse_symbol(arg)
      return Liza::Error if arg == :error

      Object.const_get(arg.to_s.camelcase)
    rescue NameError
      msg = "rescue_from parsed to #{arg.to_s.camelcase} which does not exist"
      puts msg.red
      raise
    end

    def _rescue_from_parse_symbols(args)
      namespace = Liza.const(args[0])
      begin
        namespace.const_get("#{args[1].to_s.camelcase}Error")
      rescue NameError
        msg = "rescue_from parsed to #{args[0].to_s.camelcase}::#{args[1].to_s.camelcase}Error which does not exist"
        puts msg.red
        raise
      end
    end

    #

    def rescuers
      @rescuers ||= []
    end

    #

    def rescue_from_panel(exception, with: )
      rescuer = _rescue_from_panel_find exception
      raise exception.class, exception.message, caller[1..-1] unless rescuer

      ret = nil

      log "rescuer = #{rescuer.inspect}" if get :log_details
      case with
      when Array
        with.push(rescuer)
        rescuer[:args] = with
        ret = rescuer.call
      when Hash
        with[:rescuer] = rescuer
        ret = rescuer.call
      else
        raise ArgumentError, "wrong argument type #{with.class} (expected Array or Hash)"
      end

      ret
    end

    def _rescue_from_panel_find(exception)
      rescuer = rescuers.reverse.find { exception.class.ancestors.include? _1[:exception_class] }
      log "rescuer = #{rescuer.inspect}" if get :log_details
      return nil unless rescuer
      rescuer = rescuer.dup
      rescuer[:exception] = exception
      rescuer
    end

    #

    class Rescuer < Hash
      def call(&block)
        if self[:block]
          self[:block].call self
        elsif block_given?
          yield
        else
          self[:with].call self[:args]
        end
      end
    end

  end
end
