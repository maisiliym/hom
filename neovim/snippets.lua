local U = require'snippets.utils'

inoremap('<c-e>', [[<cmd>lua return require'snippets'.advance_snippet(-1)<CR>]])
inoremap('<c-n>', [[<cmd>lua return require'snippets'.expand_or_advance(1)<CR>]])

require'snippets'.snippets = {
  lua = {
    ["for"] = U.match_indentation [[
    for ${1:i}, ${2:v} in ipairs(${3:t}) do
      $0
    end]];
    -- ["for"] = [[
    -- for ${1:i}, ${2:v} in ipairs(${3:t}) do
    -- ${-1=line_indent()}	$0
    -- ${-1}end]];
    fori = U.match_indentation [[
    for ${1:i} = ${2:1}, ${3:#t} do
      $0
    end]];
    forp = U.match_indentation [[
    for ${1:k}, ${2:v} in pairs(${3:t}) do
      $0
    end]];
    -- func = [[function${1|test123}(${2|vim.trim})$0 end]]; 
    func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]];
    req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']];
    luv = "local uv = require 'luv'";
    loc = "local $1 = $0";
    exp = "$1 = $1;";
    ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
  };

  c = {
    guard = [[
    #ifndef AK_${1|S.v:gsub("%s+", "_")}_H_
    #define AK_${|S[1]:gsub("%s+", "_")}_H_

    $0

    #endif // AK_${|S[1]:gsub("%s+", "_")}_H_
    ]];
    ["#if"] = [[
    #if $1
    $0
    #endif // $1
    ]];
    ["inc"] = [[#include "$1"]];
    ["sinc"] = [[#include <$1>]];
    ["struct"] = U.match_indentation [[
    typedef struct $1 {
      $0
    } $1;
    ]];
    ["enum"] = U.match_indentation [[
    typedef enum $1 {
      $0
    } $1;
    ]];
    ["union"] = U.match_indentation [[
    union $1 {
      $0
    }
    ]];
    ["def"] = [[#define ]];
    ["for"] = U.match_indentation [[
    for ($1; $2; $3) {
      $0
    }]];
    ["fori"] = U.match_indentation [[
    for (int ${1:i}; $1 < $2; $1++) {
      $0
    }]];
  };

  rust = {
    macro = U.match_indentation [[
    macro_rules! ${1:name} {
      ($2) => {
        $0
      }
    }
    ]];
    type = [[type $1 = $2;]];
    struct = U.match_indentation [[
    struct $1 {
      $0
    }]];
    enum = U.match_indentation [[
    enum $1 {
      $0
    }]];
    -- TODO(ashkan, 2020-08-19 05:33:54+0900) case change from TitleCase to snake_case for last element of ::
    field = [[$1: $2,]];
    -- field = [[${2=R.case_change.S[1]..}: $1,]];
    impl = U.match_indentation [[
    impl $1 {
      $0
    }
    ]];
    hashmap = [[use std::collections::HashMap;]];
    hashset = [[use std::collections::HashSet;]];
    collections = [[use std::collections::$1;]];
    match = U.match_indentation [[
    match $1 {
      $0
    }]];
    bcase = U.match_indentation [[
    $1 => {
      $0
    }]];
    case = U.match_indentation [[$1 => $0,]]
  };

  latex = {
    gfx = [[
    \begin{figure}[$1]
    \centering
    \includegraphics[${3:width=$2cm}]{$2}
    \caption{$4}
    \label{fig:$5}
    \end{figure}
    ]]
  };

  _global = {
    date = "${=os.date()}";
    ymd = [[${=os.date("%Y-%m-%d")}]];
    epoch = "${=os.time()}";
    uname = function() return vim.loop.os_uname().sysname end;
  };
}

