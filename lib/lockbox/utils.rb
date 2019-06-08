class Lockbox
  class Utils
    def self.build_box(context, options)
      options = options.dup
      options.each do |k, v|
        if v.is_a?(Proc)
          options[k] = context.instance_exec(&v) if v.respond_to?(:call)
        elsif v.is_a?(Symbol)
          options[k] = context.send(v)
        end
      end

      Lockbox.new(options)
    end

    def self.encrypted_options(record, name)
      record.class.respond_to?(:encrypted_attachments) && record.class.encrypted_attachments[name.to_sym]
    end

    def self.encrypted?(record, name)
      encrypted_options(record, name).present?
    end

    def self.encrypt_attachable(record, name, attachable)
      options = encrypted_options(record, name)
      box = build_box(record, options)

      case attachable
      when ActiveStorage::Blob
        raise NotImplementedError, "Not supported"
      when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
        attachable = {
          io: StringIO.new(box.encrypt(attachable.read)),
          filename: attachable.original_filename,
          content_type: attachable.content_type
        }
      when Hash
        attachable = {
          io: StringIO.new(box.encrypt(attachable[:io].read)),
          filename: attachable[:filename],
          content_type: attachable[:content_type]
        }
      when String
        raise NotImplementedError, "Not supported"
      else
        nil
      end

      attachable
    end
  end
end
