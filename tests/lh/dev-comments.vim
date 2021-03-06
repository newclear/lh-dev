"=============================================================================
" $Id$
" File:         tests/lh/dev-comments.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      0.0.2
" Created:      05th Nov 2010
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       «description»
" 
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/tests/lh
"       Requires Vim7+
"       «install details»
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

UTSuite [lh-dev] Testing lh#dev#purge_comments function

runtime autoload/lh/dev.vim

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! s:Setup()
  let s:ECcommentOpen  = b:ECcommentOpen
  let s:ECcommentClose = b:ECcommentClose
  let s:commentstring  = &commentstring
endfunction

function! s:Teardown()
  let b:ECcommentOpen  = s:ECcommentOpen
  let b:ECcommentClose = s:ECcommentClose
  let  &commentstring  = s:commentstring
endfunction

function! s:Test_mono_line_cpp()
  let b:ECcommentOpen  = '//'
  let b:ECcommentClose = ''
  let  &commentstring  = '/*%s*/'

  Assert ['', 0] == lh#dev#purge_comments('', 0, 'cpp')
  Assert ['', 1] == lh#dev#purge_comments('', 1, 'cpp')
  Assert ['', 0] == lh#dev#purge_comments('// toto', 0, 'cpp')
  Assert ['', 1] == lh#dev#purge_comments('// toto', 1, 'cpp')
  Assert ['titi tutu ', 0] == lh#dev#purge_comments('titi tutu // toto', 0, 'cpp')
  Assert ['', 1] == lh#dev#purge_comments('titi tutu // toto', 1, 'cpp')
endfunction

function! s:Test_region_cpp()
  let b:ECcommentOpen  = '//'
  let b:ECcommentClose = ''
  let  &commentstring  = '/*%s*/'

  Assert ['', 0] == lh#dev#purge_comments('/**/', 0, 'cpp')
  Assert ['', 1] == lh#dev#purge_comments('/*', 1, 'cpp')
  Assert ['', 0] == lh#dev#purge_comments('/* toto*/', 0, 'cpp')
  Assert ['', 0] == lh#dev#purge_comments('/* toto*/', 1, 'cpp')
  Assert ['titi  foo ', 0] == lh#dev#purge_comments('titi /*tutu*/ foo // toto', 0, 'cpp')
  Assert [' foo ', 0] == lh#dev#purge_comments('titi /*tutu*/ foo // toto', 1, 'cpp')
  Assert [' foo ', 0] == lh#dev#purge_comments('titi /*tutu*/ foo // toto /*', 1, 'cpp')
  Assert [' foo ', 1] == lh#dev#purge_comments('titi /*tutu*/ foo /* toto /*', 1, 'cpp')
endfunction

function! s:Test_mono_line_vim()
  let b:ECcommentOpen  = '"'
  let b:ECcommentClose = ''
  let  &commentstring  = '"%s'
  Assert ['', 0] == lh#dev#purge_comments('', 0, 'vim')
  Assert ['', 0] == lh#dev#purge_comments('" toto', 0, 'vim')
  Assert ['toto ', 0] == lh#dev#purge_comments('toto " toto', 0, 'vim')

  " ouch! it also purge string ...
endfunction

let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
