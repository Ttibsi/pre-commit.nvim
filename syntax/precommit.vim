if exists('b:current_syntax')
    finish
endif

syntax match pcLine /^[a-zA-Z0-9_\-]\+\.\.\.\.\+.*$/ contains=pcTool,pcDots,pcSkipped,pcFailed,pcPassed
syntax match pcTool /^[a-zA-Z0-9_\-]\+/ contained
syntax match pcDots /\.\.\.\.\+/ contained
syntax keyword pcSkipped Skipped contained
syntax keyword pcFailed Failed contained
syntax keyword pcPassed Passed contained

syntax match pcId /^- hook id: / nextgroup=pcTool2
syntax match pcTool2 /[a-zA-Z0-9_\-]\+/ contained

syntax keyword pcError Error error
syntax keyword pcInfo Info info
syntax keyword pcWarn Warn warn

syntax match pcFileLine /^\([a-zA-Z0-9_\-]\+\/\)*[a-zA-Z0-9_\-]\+\.[a-zA-Z0-9]\+\(:[0-9]\+:\?\)\?/

hi def link pcSkipped Changed
hi def link pcFailed Removed
hi def link pcPassed Added
hi def link pcTool Constant
hi def link pcTool2 Constant
hi def link pcDots Comment

hi def link pcError DiagnosticError
hi def link pcInfo DiagnosticInfo
hi def link pcWarn DiagnosticWarn

hi def link pcFileLine Delimiter


let b:current_syntax = 'precommit'
