#define MODULE_NAME ps5vdec
#define MODULE_STRING "ps5vdec"

#include <vlc_common.h>
#include <vlc_codec.h>
#include <vlc_plugin.h>

void vlc_ps5_vdec_prepare(void) {}
void vlc_ps5_vdec_probe(const char *when) { (void)when; }

static int OpenDecoder(vlc_object_t *obj)
{
    (void)obj;
    return VLC_EGENERIC;
}

static void CloseDecoder(vlc_object_t *obj)
{
    (void)obj;
}

vlc_module_begin()
    set_shortname("PS5 video decoder")
    set_description("PS5 video decoder stub (FW 13.60+ safe)")
    set_category(CAT_INPUT)
    set_subcategory(SUBCAT_INPUT_VCODEC)
    set_capability("video decoder", 0)
    set_callbacks(OpenDecoder, CloseDecoder)
vlc_module_end()
