module Webpacker::Helper
  include Shakapacker::Helper

  def current_webpacker_instance
    Webpacker.instance
  end

  def stylesheet_pack_tag(*names, **options)
    return "" if Webpacker.inlining_css?

    requested_packs = sources_from_manifest_entrypoints(names, type: :stylesheet)
    appended_packs = available_sources_from_manifest_entrypoints(@stylesheet_pack_tag_queue || [], type: :stylesheet)

    @stylesheet_pack_tag_loaded = true

    stylesheet_link_tag(*(requested_packs | appended_packs), **options)
  end
end
