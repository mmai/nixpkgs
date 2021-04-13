/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_quasiquote";
  version = "trivia-20210228-git";

  description = "fare-quasiquote extension for trivia";

  deps = [ args."alexandria" args."closer-mop" args."fare-quasiquote" args."fare-quasiquote-readtable" args."fare-utils" args."lisp-namespace" args."named-readtables" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-02-28/trivia-20210228-git.tgz";
    sha256 = "0qqyspq2mryl87wgrm43sj7d2wqb1pckk7fjvnmmyrf5kz5p4pc6";
  };

  packageName = "trivia.quasiquote";

  asdFilesToKeep = ["trivia.quasiquote.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.quasiquote DESCRIPTION fare-quasiquote extension for trivia
    SHA256 0qqyspq2mryl87wgrm43sj7d2wqb1pckk7fjvnmmyrf5kz5p4pc6 URL
    http://beta.quicklisp.org/archive/trivia/2021-02-28/trivia-20210228-git.tgz
    MD5 b374212a63c1e3b7e5c0e26348516106 NAME trivia.quasiquote FILENAME
    trivia_dot_quasiquote DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-quasiquote-readtable FILENAME fare-quasiquote-readtable)
     (NAME fare-utils FILENAME fare-utils)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2))
    DEPENDENCIES
    (alexandria closer-mop fare-quasiquote fare-quasiquote-readtable fare-utils
     lisp-namespace named-readtables trivia.level0 trivia.level1 trivia.level2
     trivia.trivial trivial-cltl2)
    VERSION trivia-20210228-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level1 trivia.level2 trivia.ppcre trivia.test trivia.trivial)
    PARASITES NIL) */
