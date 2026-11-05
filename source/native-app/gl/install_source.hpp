// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once
#include <string>
#include <string_view>
namespace sx {
inline constexpr const char* donation_url="";
inline constexpr const char* donation_link="";
inline bool valid_install_source(std::string_view source) {
    return source=="store" || source=="github" || source=="unknown" || source=="local";
}
inline const char* install_source_label(std::string_view /*source*/) {
    return "Local";
}
inline std::string update_destination(std::string_view /*source*/) {
    return "";
}
}
