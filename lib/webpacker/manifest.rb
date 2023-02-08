class Webpacker::Manifest < Shakapacker::Manifest
  private

    def compile
      Webpacker.logger.tagged("Webpacker") { compiler.compile }
    end

    def handle_missing_entry(name, pack_type)
      raise Webpacker::Manifest::MissingEntryError, missing_file_from_manifest_error(full_pack_name(name, pack_type[:type]))
    end
end
