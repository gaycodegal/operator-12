#pragma once
#include <algorithm>
#include <cctype>
#include <iterator>
#include <locale>
#include <sstream>
#include <string>
#include <vector>

namespace util {
static inline std::vector<std::string> split_whitespace(
    const std::string& white_string) {
  std::istringstream stream(white_string);
  std::vector<std::string> result(std::istream_iterator<std::string>{stream},
                                  std::istream_iterator<std::string>());
  return result;
}

static inline std::vector<std::string> split(const std::string& whole_string,
                                             char sep) {
  std::istringstream stream(whole_string);
  std::vector<std::string> result;
  std::string temp;
  while (std::getline(stream, temp, sep)) {
    result.push_back(temp);
  }
  return result;
}

/**
   trim from the left of the string
 */
static inline std::string& ltrim(std::string& s) {
  s.erase(s.begin(), std::find_if(s.begin(), s.end(),
                                  [](int c) { return !std::isspace(c); }));
  return s;
}

/**
   trim from the right of the string
 */
static inline std::string& rtrim(std::string& s) {
  s.erase(
      std::find_if(s.rbegin(), s.rend(), [](int c) { return !std::isspace(c); })
          .base(),
      s.end());
  return s;
}

/**
   standard trim
 */
static inline std::string& trim(std::string& s) {
  ltrim(s);
  return rtrim(s);
}
}  // namespace util
