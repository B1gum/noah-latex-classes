\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{noahassignment}[2026/08/04 My problem-sheet assignment class]

% ---------------------------------------------------------------------------
% Options
% ---------------------------------------------------------------------------
\newif\ifnoah@assignment \noah@assignmenttrue
\newif\ifnoah@notes      \noah@notesfalse
\newif\ifnoah@danish     \noah@danishfalse
\newif\ifnoah@anonymous  \noah@anonymousfalse
\newif\ifnoah@draft      \noah@draftfalse
\newif\ifnoah@print      \noah@printfalse
\def\noah@language{english}

\DeclareOption{english}{\def\noah@language{english}\noah@danishfalse}
\DeclareOption{danish}{\def\noah@language{danish}\noah@danishtrue}
\DeclareOption{anonymous}{\noah@anonymoustrue}
\DeclareOption{draft}{\noah@drafttrue}
\DeclareOption{final}{\noah@draftfalse}
\DeclareOption{print}{\noah@printtrue}
\DeclareOption{screen}{\noah@printfalse}
\DeclareOption{oneside}{}
\DeclareOption{twoside}{\ClassError{noahassignment}{Assignments should be one-sided}{Remove the twoside option.}}
\DeclareOption*{\ClassError{noahassignment}{Unknown option `\CurrentOption'}{Allowed options: english, danish, anonymous, draft, final, print, screen, oneside.}}
\ProcessOptions\relax

\LoadClass[11pt,a4paper,oneside]{article}
\RequirePackage{noah-common}
\RequirePackage{titlesec}
\RequirePackage{lastpage}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}

% Assignment layout
\geometry{a4paper,top=27mm,bottom=27mm,left=28mm,right=28mm,headheight=32pt,headsep=8mm,footskip=14mm}

\setstretch{1.25}

\setlength{\parskip}{0.62\baselineskip plus 2pt minus 2pt}

% Captions
\NoahConfigureListsAndCaptions{5pt}{3pt}{true}

% Links
\ifnoah@print
  \hypersetup{hidelinks}
\else
  \hypersetup{colorlinks=true,linkcolor=AUblueDark,urlcolor=AUblueDark,citecolor=black}
\fi

% ---------------------------------------------------------------------------
% Headings
% ---------------------------------------------------------------------------
\titleformat{\section}
  {\Large\bfseries\sffamily\color{AUblueDark}}
  {\thesection}{0.75em}{}
\titleformat{\subsection}
  {\large\bfseries\sffamily\color{AUblueDark}}
  {\thesubsection}{0.65em}{}
\titleformat{\subsubsection}
  {\normalsize\bfseries\sffamily\color{AUblue}}
  {\thesubsubsection}{0.55em}{}
\titlespacing*{\section}{0pt}{1.4\baselineskip}{0.45\baselineskip}
\titlespacing*{\subsection}{0pt}{1.0\baselineskip}{0.3\baselineskip}
\titlespacing*{\subsubsection}{0pt}{0.8\baselineskip}{0.2\baselineskip}
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}
\NoahInstallTitleCasing

% Contents typography mirrors the in-text heading hierarchy.
\renewcommand{\cftsecfont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsecpagefont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsubsecfont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsubsecpagefont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsubsubsecfont}{\sffamily\color{AUblue}}
\renewcommand{\cftsubsubsecpagefont}{\sffamily\color{AUblue}}
\renewcommand{\cftsecdotsep}{\cftdotsep}

% ---------------------------------------------------------------------------
% Assignment-specific setup keys
% ---------------------------------------------------------------------------
\ExplSyntaxOn
\bool_new:N \g_noah_manual_problem_bool
\bool_new:N \g_noah_toc_subproblems_bool
\tl_new:N \g_noah_subproblem_numbering_tl
\bool_gset_false:N \g_noah_manual_problem_bool
\bool_gset_true:N \g_noah_toc_subproblems_bool
\tl_gset:Nn \g_noah_subproblem_numbering_tl {letters}

\keys_define:nn {noah/setup}
  {
    problem-numbering .choice:,
    problem-numbering / automatic .code:n = {\bool_gset_false:N\g_noah_manual_problem_bool},
    problem-numbering / manual .code:n = {\bool_gset_true:N\g_noah_manual_problem_bool},
    subproblem-numbering .choice:,
    subproblem-numbering / letters .code:n = {\tl_gset:Nn\g_noah_subproblem_numbering_tl{letters}},
    subproblem-numbering / decimal .code:n = {\tl_gset:Nn\g_noah_subproblem_numbering_tl{decimal}},
    subproblem-numbering / compact .code:n = {\tl_gset:Nn\g_noah_subproblem_numbering_tl{compact}},
    toc-subproblems .bool_gset:N = \g_noah_toc_subproblems_bool
  }
\ExplSyntaxOff

% ---------------------------------------------------------------------------
% Header and footer
% ---------------------------------------------------------------------------
\newcommand{\NoahAssignmentRunningHead}{%
  \makebox[\headwidth][c]{%
    \begin{minipage}[t]{0.22\headwidth}
      \raggedright\scriptsize\sffamily\color{AUblueDark}
      \ifnoah@anonymous\NoahCandidateNumber\else\NoahAuthorSurnames\fi
    \end{minipage}\hfill
    \begin{minipage}[t]{0.52\headwidth}
      \centering\scriptsize\sffamily\color{AUblue}\NoahRunningTitle
    \end{minipage}\hfill
    \begin{minipage}[t]{0.18\headwidth}
      \raggedleft\scriptsize\sffamily\color{AUblueDark}\NoahSubmissionDateISO
    \end{minipage}%
  }%
}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrule}{\hbox to\headwidth{\color{AUblueDark}\leaders\hrule height 0.45pt\hfill}}
\renewcommand{\footrulewidth}{0pt}
\fancyhead[C]{\NoahAssignmentRunningHead}
\fancyfoot[L]{\small\sffamily\color{AUblueDark}\NoahCourseRunning}
\fancyfoot[R]{\small\sffamily\color{AUblueDark}\NoahPageAbbrev~\thepage~\NoahLabelOf~\pageref*{LastPage}}

% ---------------------------------------------------------------------------
% Front matter and title page
% ---------------------------------------------------------------------------
\newif\ifnoah@assignmentresetpending
\noah@assignmentresetpendingfalse

\renewcommand{\maketitle}{%
  \hypersetup{pageanchor=false}%
  \begin{titlepage}
    \NoahTitleStripe
    \thispagestyle{empty}
    \vspace*{7mm}
    {\large\bfseries\sffamily\NoahDepartment\par}
    {\normalsize\sffamily\NoahUniversity\par}
    \vspace{27mm}
    {\fontsize{28pt}{31pt}\selectfont\bfseries\sffamily\ReportTitle\par}
    \vspace{10mm}
    {\color{AUblueDark}\rule{\linewidth}{1.4pt}}
    \vspace{8mm}
    \begingroup
    \setstretch{1.05}
    \begin{tabularx}{\dimexpr\linewidth-2pt\relax}{@{}>{\raggedright\arraybackslash}p{38mm}X@{}}
      \ifnoah@anonymous
        \NoahCandidateMetadataRow
      \else
        \NoahAssignmentAuthorRows
      \fi
      \NoahCourseMetadataRow
      \NoahInstructorMetadataRow
      \NoahSemesterMetadataRow
      \NoahSubmissionMetadataRow
    \end{tabularx}
    \endgroup
    \vfill
    \begin{flushright}\NoahIncludeLogo{42mm}\end{flushright}
  \end{titlepage}%
  \ifnoah@infrontmatter\setcounter{page}{2}\fi
  \hypersetup{pageanchor=true}%
  \ifnoah@infrontmatter\else
    \global\noah@assignmentresetpendingtrue
  \fi
}

\AtBeginDocument{%
  \NoahIfBlankTF{\@title}
    {\ClassWarning{noahassignment}{No title has been set}}
    {}
  \NoahIfBlankTF{\NoahCourseName}
    {\ClassWarning{noahassignment}{No course has been set in \string\documentsetup}}
    {}
  \NoahIfBlankTF{\NoahSubmissionDate}
    {\ClassWarning{noahassignment}{No submission-date has been set in \string\documentsetup}}
    {}
  \ifnoah@anonymous
    \NoahIfBlankTF{\NoahCandidateNumber}
      {\ClassWarning{noahassignment}{Anonymous mode is active but no candidate-number is set}}
      {}
  \fi
}

% ---------------------------------------------------------------------------
% Lecture dividers
% ---------------------------------------------------------------------------
% Keep the same interface as noahnotes so the `lec` LuaSnip expansion works in
% either class: \lecture[short title]{identifier}{date}{title}.  Assignments do
% not use the optional short title in a running header, but accept it for full
% source compatibility.
\newif\ifnoah@assignmentlecturepending
\noah@assignmentlecturependingfalse

\newcommand*\l@lecture[2]{%
  \ifnum\c@tocdepth>\z@
    \addpenalty\@secpenalty
    \addvspace{0.85\baselineskip plus 1pt}%
    \begingroup
      \leftskip\z@
      \rightskip\@tocrmarg
      \parfillskip-\rightskip
      \parindent\z@
      \interlinepenalty\@M
      \leavevmode
      {\large\sffamily\color{black}#1}%
      \nobreak\hfill\nobreak
      \hb@xt@\@pnumwidth{\hss\normalfont\normalsize\sffamily\color{black}#2}%
      \par
    \endgroup
  \fi
}
\def\toclevel@lecture{1}

\NewDocumentCommand{\lecture}{O{} m m m}{%
  % Assignment problems normally begin on fresh pages. Start the lecture on
  % that fresh page here, then suppress only the first problem's own clearpage.
  \clearpage
  \protected@edef\thelecture{#2}% manual visible identifier
  \refstepcounter{lecture}% unique hyperlink anchor + cleveref state
  \NoahStoreTitleCase{\noah@lecturetitle}{#4}%
  \protected@edef\@currentlabelname{\noah@lecturetitle}%
  \ifstrempty{#4}
    {\gdef\noah@lectureheading{\NoahLabelLecture~#2}}
    {\protected@xdef\noah@lectureheading{\NoahLabelLecture~#2: \noah@lecturetitle}}%
  \global\noah@assignmentlecturependingtrue
  \par\vspace{0.8\baselineskip}
  \noindent
  \begin{minipage}[t]{0.78\linewidth}
    \raggedright\normalsize\sffamily\color{black}\noah@lectureheading
  \end{minipage}\hfill
  \begin{minipage}[t]{0.18\linewidth}
    \raggedleft\small\sffamily\color{AUblue}#3
  \end{minipage}%
  \par\vspace{0.2\baselineskip}
  \addcontentsline{toc}{lecture}{\noah@lectureheading}%
}

% ---------------------------------------------------------------------------
% Problem and subproblem hierarchy
% ---------------------------------------------------------------------------
\newcounter{problem}
\renewcommand{\theproblem}{\arabic{problem}}
\ifnoah@danish
  \crefname{problem}{opgave}{opgaver}
  \Crefname{problem}{Opgave}{Opgaver}
\else
  \crefname{problem}{problem}{problems}
  \Crefname{problem}{Problem}{Problems}
\fi

\newcommand*\l@problem[2]{\@dottedtocline{1}{0em}{0em}{\bfseries\sffamily\color{AUblueDark}#1}{\bfseries #2}}
\newcommand*\l@subproblem[2]{\@dottedtocline{2}{1.4em}{0em}{#1}{#2}}
\def\toclevel@problem{1}
\def\toclevel@subproblem{2}

\ExplSyntaxOn
\bool_new:N \l_noah_problem_rule_bool
\keys_define:nn {noah/problem}
  {closing-rule .bool_set:N = \l_noah_problem_rule_bool}

\cs_new_protected:Npn \noah_problem_begin:nn #1#2
  {
    \ifnoah@assignmentlecturepending
      \global\noah@assignmentlecturependingfalse
    \else
      \clearpage
    \fi
    \ifnoah@assignmentresetpending
      \pagenumbering{arabic}
      \global\noah@assignmentresetpendingfalse
      \global\noah@inmainmattertrue
    \fi
    \bool_set_true:N \l_noah_problem_rule_bool
    \keys_set:nn {noah/problem}{#1}
    \bool_if:NTF \g_noah_manual_problem_bool
      {
        \IfNoValueTF{#2}
          {\ClassError{noahassignment}{Manual problem numbering requires an identifier}{Use \string\begin{problem}{A3}.}}
          {\renewcommand{\theproblem}{#2}%
           \refstepcounter{problem}%
           \def\noah@displayproblem{#2}}
      }
      {
        \IfNoValueTF{#2}
          {\refstepcounter{problem}\edef\noah@displayproblem{\theproblem}}
          {\ClassError{noahassignment}{An identifier was supplied in automatic problem mode}{Remove the identifier or set problem-numbering=manual.}}
      }
    \def\@currentlabelname{}
    \addcontentsline{toc}{problem}{\NoahLabelProblem\space\noah@displayproblem}
    \par\noindent
    {\Large\bfseries\sffamily\color{AUblueDark}\NoahLabelProblem\c_space_tl\noah@displayproblem\par}
    \vspace{0.35\baselineskip}
  }
\cs_new_protected:Npn \noah_problem_end:
  {
    \par\vspace{0.7\baselineskip}
    \bool_if:NT \l_noah_problem_rule_bool
      {{\color{AUblueDark}\rule{\linewidth}{0.8pt}}}
    \par
  }
\NewDocumentEnvironment{problem}{O{} g}
  {\noah_problem_begin:nn{#1}{#2}}
  {\noah_problem_end:}
\ExplSyntaxOff

\newlist{subproblems}{enumerate}{1}
\setlist[subproblems,1]{leftmargin=10mm,labelsep=3mm,itemsep=5mm,topsep=4pt,parsep=0pt}
\ifnoah@danish
  \crefname{subproblemsi}{delopgave}{delopgaver}
  \Crefname{subproblemsi}{Delopgave}{Delopgaver}
\else
  \crefname{subproblemsi}{subproblem}{subproblems}
  \Crefname{subproblemsi}{Subproblem}{Subproblems}
\fi

\ExplSyntaxOn
\cs_new_protected:Npn \noah_setup_subproblem_numbering:
  {
    \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {letters}
      {
        \setlist[subproblems,1]{label=\textbf{(\alph*)},ref=\theproblem(\alph*)}
        \cs_gset:Npn \noah_subproblem_toc_text: {(\alph{subproblemsi})}
      }
      {
        \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {decimal}
          {
            \setlist[subproblems,1]{label=\textbf{\theproblem.\arabic*},ref=\theproblem.\arabic*}
            \cs_gset:Npn \noah_subproblem_toc_text: {\theproblem.\arabic{subproblemsi}}
          }
          {
            \setlist[subproblems,1]{label=\textbf{\theproblem\alph*},ref=\theproblem\alph*}
            \cs_gset:Npn \noah_subproblem_toc_text: {\theproblem\alph{subproblemsi}}
          }
      }
  }
\AtBeginDocument{\noah_setup_subproblem_numbering:}
\NewDocumentCommand{\subproblem}{s}
  {
    \item
    \def\@currentlabelname{}
    \IfBooleanF{#1}
      {\bool_if:NT \g_noah_toc_subproblems_bool
        {\edef\noah@tocentry{\noah_subproblem_toc_text:}\addcontentsline{toc}{subproblem}{\noah@tocentry}}}
  }
\ExplSyntaxOff

% ---------------------------------------------------------------------------
% Assignment-only structural helpers
% ---------------------------------------------------------------------------
\newcommand{\AUheading}[1]{%
  \par\vspace{0.45\baselineskip}
  {\sffamily\bfseries\color{AUblueDark}#1\par}\nobreak
}

\newenvironment{assumptions}[1][\NoahLabelAssumptions]{%
  \AUheading{#1}
  \begin{itemize}[nosep]
}{\end{itemize}\par\medskip}

\newenvironment{givens}[1][\NoahLabelGivens]{%
  \AUheading{#1}
  \begin{center}
  \begin{tabular}{>{$}r<{$} !{\color{AUblueDark}\vrule width 0.8pt} l}
}{%
  \end{tabular}
  \end{center}
}

% A derivation may be used either as a plain block (the legacy interface) or
% as a list of derivation parts matching the problem's subproblem list.  The
% parts use the same numbering scheme, indentation, and rhythm as subproblems.
% Each subresult is shown in place and repeated in the collected final result.
\ExplSyntaxOn
\int_new:N  \g_noah_derivation_result_count_int
\tl_new:N   \l_noah_derivation_current_ref_tl
\tl_new:N   \l_noah_derivation_current_display_tl
\bool_new:N \l_noah_derivation_parts_bool
\bool_new:N \l_noah_derivation_part_has_result_bool
\int_new:N  \l_noah_derivation_part_int

\newlist{derivationparts}{enumerate}{1}
\setlist[derivationparts,1]
  {
    leftmargin=10mm,
    labelsep=3mm,
    itemsep=10mm,
    topsep=4pt,
    parsep=0pt
  }

\cs_new_protected:Npn \noah_setup_derivation_numbering:
  {
    \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {letters}
      {
        \setlist[derivationparts,1]
          {label=\textbf{(\alph*)},ref=\theproblem(\alph*)}
      }
      {
        \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {decimal}
          {
            \setlist[derivationparts,1]
              {label=\textbf{\theproblem.\arabic*},ref=\theproblem.\arabic*}
          }
          {
            \setlist[derivationparts,1]
              {label=\textbf{\theproblem\alph*},ref=\theproblem\alph*}
          }
      }
  }
\AtBeginDocument{\noah_setup_derivation_numbering:}

\cs_new:Npn \noah_derivation_local_label:
  {
    \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {letters}
      {(\int_to_alph:n {\l_noah_derivation_part_int})}
      {
        \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {decimal}
          {\theproblem.\int_to_arabic:n {\l_noah_derivation_part_int}}
          {\theproblem\int_to_alph:n {\l_noah_derivation_part_int}}
      }
  }

\cs_new:Npn \noah_derivation_index_label:n #1
  {
    \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {letters}
      {(\int_to_alph:n {#1})}
      {
        \tl_if_eq:VnTF \g_noah_subproblem_numbering_tl {decimal}
          {\theproblem.\int_to_arabic:n {#1}}
          {\theproblem\int_to_alph:n {#1}}
      }
  }

\cs_new:Npn \noah_derivation_part_heading:
  {\tl_use:N \l_noah_derivation_current_display_tl}

\cs_new_protected:Npn \noah_derivation_summary_entry:nnn #1#2#3
  {
    \par\noindent
    \makebox[10mm][l]
      {\sffamily\bfseries\color{AUblueDark}#2}%
    \begin{minipage}[t]{\dimexpr\linewidth-10mm\relax}
      #3
    \end{minipage}
    \par
  }

\cs_new_protected:Npn \noah_derivation_begin:n #1
  {
    \par\vspace{0.85\baselineskip}
    {\Large\bfseries\sffamily\color{AUblueDark}#1\par}
    \vspace{0.35\baselineskip}
    \begingroup
    \allowdisplaybreaks
    \setlength{\abovedisplayskip}{8pt}
    \setlength{\belowdisplayskip}{8pt}
    \setlength{\abovedisplayshortskip}{6pt}
    \setlength{\belowdisplayshortskip}{6pt}
    \int_gzero:N \g_noah_derivation_result_count_int
    \tl_clear:N \l_noah_derivation_current_ref_tl
    \tl_clear:N \l_noah_derivation_current_display_tl
    \bool_set_false:N \l_noah_derivation_parts_bool
    \bool_gset_false:N \l_noah_derivation_part_has_result_bool
  }

\cs_new_protected:Npn \noah_derivation_end:
  {
    \bool_if:NT \l_noah_derivation_parts_bool
      {
        \bool_if:NF \l_noah_derivation_part_has_result_bool
          {\ClassWarning{noahassignment}{The final derivation part has no subresult}}
        \end{derivationparts}
        \par\vspace{0.55\baselineskip}
        {\color{AUblueDark}\rule{\linewidth}{0.8pt}}
        \par\vspace{0.7\baselineskip}
        \int_compare:nNnT {\g_noah_derivation_result_count_int} > {0}
          {
            \begin{finalresult}[title={\NoahLabelFinalResult\space--\space
              \NoahLabelProblem\space\theproblem}]
              \int_step_inline:nn {\g_noah_derivation_result_count_int}
                {
                  \int_compare:nNnT {##1} > {1}
                    {\par\medskip{\color{AUblue!35}\hrule height 0.5pt}\medskip}
                  \noah_derivation_summary_entry:nnn
                    {}
                    {\noah_derivation_index_label:n {##1}}
                    {\tl_use:c {g_noah_derivation_body_##1_tl}}
                }
            \end{finalresult}
          }
        \int_gzero:N \g_noah_derivation_result_count_int
        \bool_gset_false:N \l_noah_derivation_part_has_result_bool
      }
    \par\endgroup\medskip
  }

\NewDocumentEnvironment{derivation}{O{\NoahLabelDerivation}}
  {\noah_derivation_begin:n{#1}}
  {\noah_derivation_end:}

% Optional argument links the part to the corresponding subproblem label.
% The displayed marker is generated exactly like the original subproblem list.
\NewDocumentCommand{\derivationpart}{o}
  {
    \bool_if:NTF \l_noah_derivation_parts_bool
      {
        \bool_if:NF \l_noah_derivation_part_has_result_bool
          {\ClassWarning{noahassignment}{The preceding derivation part has no subresult}}
      }
      {
        \bool_set_true:N \l_noah_derivation_parts_bool
        \begin{derivationparts}
      }
    \item
    \int_set:Nn \l_noah_derivation_part_int {\value{derivationpartsi}}
    \tl_set:Nx \l_noah_derivation_current_display_tl
      {\noah_derivation_local_label:}
    \IfNoValueTF{#1}
      {\tl_clear:N \l_noah_derivation_current_ref_tl}
      {\tl_set:Nn \l_noah_derivation_current_ref_tl {#1}}
    \bool_gset_false:N \l_noah_derivation_part_has_result_bool
  }

\NewDocumentEnvironment{subresult}{+b}
  {
    \bool_if:NTF \l_noah_derivation_parts_bool
      {
        \begin{result}
          #1
        \end{result}
        \int_gincr:N \g_noah_derivation_result_count_int
        \tl_gset:cn
          {g_noah_derivation_body_\int_use:N\g_noah_derivation_result_count_int _tl}
          {#1}
        \bool_gset_true:N \l_noah_derivation_part_has_result_bool
      }
      {
        \ClassError{noahassignment}
          {subresult requires a derivationpart}
          {Use subresult only after \string\derivationpart\space inside derivation.}
      }
  }
  {}
\ExplSyntaxOff

\NewDocumentCommand{\exercise}{m}{%
  \par\vspace{0.85\baselineskip}
  {\large\bfseries\sffamily\color{AUblueDark}\NoahLabelExercise~#1\par}
  \vspace{0.25\baselineskip}
}

% ---------------------------------------------------------------------------
% Two-level result family 2
% ---------------------------------------------------------------------------
\newtcolorbox{result}[1][]{%
  enhanced,sharp corners,breakable,frame hidden,boxrule=0pt,
  borderline west={2pt}{0pt}{AUblue},colback=white,
  left=10pt,right=4pt,top=5pt,bottom=5pt,
  before skip=7pt,after skip=7pt,
  fonttitle=\bfseries\sffamily\color{AUblueDark},title=\NoahLabelResult,
  #1
}
\newtcolorbox{finalresult}[1][]{%
  enhanced,sharp corners,breakable,frame hidden,boxrule=0pt,
  borderline west={4pt}{0pt}{AUblueDark},colback=AUblue!5,
  colbacktitle=AUblue!5,coltitle=AUblueDark,
  left=12pt,right=9pt,top=8pt,bottom=8pt,
  before skip=9pt,after skip=9pt,
  fonttitle=\bfseries\sffamily\color{AUblueDark},title=\NoahLabelFinalResult,
  #1
}

% ---------------------------------------------------------------------------
% Short problem statement with an ordinary image on the right
% ---------------------------------------------------------------------------
\newlength{\pbfigsep}
\setlength{\pbfigsep}{6mm}
\NewDocumentEnvironment{problemwithimage}{O{0.42\linewidth} m g}{%
  \IfNoValueTF{#3}{\begin{problem}}{\begin{problem}{#3}}
  \noindent
  \begin{minipage}[t]{\dimexpr\linewidth-#1-\pbfigsep\relax}
  \vspace{0pt}
}{%
  \end{minipage}\hfill
  \begin{minipage}[t]{#1}
    \vspace{0pt}\centering
    \includegraphics[width=\linewidth]{#2}
  \end{minipage}
  \end{problem}
}

% Assignment figures and tables are numbered continuously.
