class Liza::TestSubjectPart < Liza::Part

  insertion do
    def self.subject_class
      @subject_class ||=
        if first_namespace == "Liza"
          Liza.const_get last_namespace[0..-5]
        else
          Object.const_get name[0..-5]
        end
    end

    def subject_class
      self.class.subject_class
    end

    def subject
      @subject ||= subject_class.new
    end

    def self.system
      subject_class.system
    rescue
      System
    end

    def system
      self.class.system
    end
  end

end
