// SPDX-License-Identifier: GPL-3.0-or-later
#include "session.hpp"
namespace sx {
void Session::install_source_choose(int /*index*/) {
    prefs_.install_source = "local";
    install_source_dialog_ = false;
    install_source_first_ = false;
    save_prefs();
    refresh_settings();
    if(login_after_notes_) { login_after_notes_ = false; login_start(); }
}

void Session::install_source_menu(bool /*first*/) {
    install_source_dialog_ = false;
    install_source_first_ = false;
    prefs_.install_source = "local";
    if(login_after_notes_) { login_after_notes_ = false; login_start(); }
}

void Session::update_menu() {
    open_dropdown("Nuvio with Torrents", {"Close"}, 0, [](int){});
    dropdown.message = "Nuvio with Torrents is running the latest version (" + std::string(nuvio_update::current_version) + ").";
    update_dialog_ = true;
}

void Session::update_status() {
    startup_update_checked_ = true;
    const auto s = updater_.status();
    if(s.phase == AppUpdate::Phase::closing) { exit_ = true; return; }
}
}
