\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rdproject}[2026/10/08 Noah's engineering project-report class]

% Options
\newif\ifnoah@danish     \noah@danishfalse
\newif\ifnoah@anonymous  \noah@anonymousfalse
\newif\ifnoah@draft      \noah@draftfalse
\newif\ifnoah@print      \noah@printfalse
\newif\ifnoah@class@twoside \noah@class@twosidefalse
\def\noah@language{english}

\DeclareOption{draft}{\noah@drafttrue}
\DeclareOption{final}{\noah@draftfalse}

\DeclareOption{print}{\noah@printtrue}
\DeclareOption{screen}{\noah@printfalse}

\DeclareOption{twoside}{\noah@class@twosidetrue}
\DeclareOption{oneside}{\noah@class@twosidefalse}

\DeclareOption*{%
  \ClassError{rdproject}
    {Unknown option `\CurrentOption'}
    {Allowed options: draft, final, print, screen, twoside, oneside.}%
}

\ProcessOptions\relax

\ifnoah@class@twoside
  \LoadClass[11pt,a4paper,twoside,openany]{report}
\else
  \LoadClass[11pt,a4paper,oneside,openany]{report}
\fi

\PassOptionsToPackage{
  style=ieee,
  sorting=none
}{biblatex}

\RequirePackage{noah-common}
\RequirePackage{titlesec}
\RequirePackage[toc,nonumberlist]{glossaries-extra}
\RequirePackage{longtable}

\makeglossaries

% Custom glossary field for units
\glsaddstoragekey{unit}{}{\glsentryunit}
\glssetnoexpandfield{unit}

\newglossarystyle{NoahNomenclature}{%
  \renewenvironment{theglossary}{%
    \begin{longtable}{@{}
      >{\raggedright\arraybackslash}p{0.16\textwidth} % 16% - 60% - 16%
      >{\raggedright\arraybackslash}p{0.60\textwidth}
      >{\raggedleft\arraybackslash}p{0.16\textwidth}
    @{}}
  }{%
    \end{longtable}
  }%

  \renewcommand*{\glossaryheader}{%
    \toprule
    \textbf{Symbol} &
    \textbf{Description} &
    \textbf{Unit}
    \tabularnewline
    \midrule
    \endhead
    \bottomrule
    \endfoot
  }%

  \renewcommand*{\glsgroupheading}[1]{%
    \multicolumn{3}{@{}l@{}}{%
      \sffamily\bfseries\color{AUblueDark}%
      \ifstrequal{##1}{A}{Roman Symbols}{%
      \ifstrequal{##1}{B}{Greek Symbols}{%
      \ifstrequal{##1}{C}{Dimensionless Numbers}{%
      \ifstrequal{##1}{D}{Abbreviations}{##1}}}}%
    }%
    \tabularnewline[0.35em]
  }%

  \renewcommand*{\glossentry}[2]{%
    \glstarget{##1}{\glossentryname{##1}} &
    \glossentrydesc{##1} &
    \glsentryunit{##1}%
    \tabularnewline
  }%

  \renewcommand*{\subglossentry}[3]{}%
  \renewcommand*{\glsgroupskip}{}%
}

\ExplSyntaxOn
\tl_gset:Nn \g_noah_pdf_subject_tl {Engineering~project~report}
\ExplSyntaxOff

% Layout and typography
\if@twoside
  \geometry{
    top=24mm,
    bottom=25mm,
    inner=27mm,
    outer=23mm,
    headheight=30pt,
    headsep=7mm,
    footskip=12mm
  }
\else
  \geometry{
    top=24mm,
    bottom=25mm,
    left=24mm,
    right=24mm,
    headheight=30pt,
    headsep=7mm,
    footskip=12mm}
\fi

\setstretch{1.15}
\setlength{\parskip}{0.30\baselineskip plus 0.5pt minus 0.5pt}
\NoahConfigureListsAndCaptions{4pt}{2pt}{false}

\ifnoah@print
  \hypersetup{hidelinks}
\else
  \hypersetup{colorlinks=true,linkcolor=AUblueDark,urlcolor=AUblueDark,citecolor=AUblueDark}
\fi

% Project metadata
\ExplSyntaxOn
\tl_new:N \g_noah_project_supervisor_tl

\keys_define:nn {noah/setup}
  {
    supervisor .tl_gset:N = \g_noah_project_supervisor_tl
  }

\NewDocumentCommand{\NoahSupervisorMetadataRow}{}{%
  \tl_if_blank:VF \g_noah_project_supervisor_tl
    {
      \textbf{\sffamily Supervisor}
      & \tl_use:N \g_noah_project_supervisor_tl
      \\[1mm]
    }
}

\cs_new_protected:Npn \NoahProjectAuthorRows
  {
    \int_set:Nn \l_tmpa_int {\seq_count:N\g_noah_author_name_seq}

    \seq_map_indexed_inline:Nn \g_noah_author_name_seq
      {
        \int_compare:nNnTF {##1} = {1}
          {
            \textbf{\sffamily
              \int_compare:nNnTF {\l_tmpa_int} > {1}
                {\NoahLabelAuthors}{\NoahLabelAuthor}} &
          }
          {&}

        ##2
        \tl_if_blank:eF {\seq_item:Nn\g_noah_author_id_seq{##1}}
          {
            \hfill
            {\scriptsize\sffamily\color{AUgray}\NoahLabelStudentID{}:}\enspace
            \seq_item:Nn\g_noah_author_id_seq{##1}
          }
        \\[1.5mm]
      }
  }

\NewDocumentCommand{\NoahProjectCourseMetadataRow}{}{%
  \tl_if_blank:VF \g_noah_course_tl
    {
      \textbf{\sffamily\NoahLabelCourse} &
      \begin{tabularx}{\linewidth}{@{}X>{\raggedleft\arraybackslash}l@{}}
        \NoahCourseName &
        \tl_if_blank:VF \g_noah_course_code_tl
          {
            {\scriptsize\sffamily\color{AUgray}\NoahLabelCourseCode{}:}\enspace
            \NoahCourseCode
          }
      \end{tabularx}
      \\[1mm]
    }
}
\ExplSyntaxOff

% Headings
\titleformat{\chapter}[hang]
  {\Huge\bfseries\sffamily\color{AUblueDark}}
  {\thechapter}{0.75em}{}
\titleformat{name=\chapter,numberless}[block]
  {\Huge\bfseries\sffamily\color{AUblueDark}}
  {}{0pt}{}
\titleformat{\section}
  {\Large\bfseries\sffamily\color{AUblueDark}}
  {\thesection}{0.75em}{}
\titleformat{\subsection}
  {\large\bfseries\sffamily\color{AUblue}}
  {\thesubsection}{0.65em}{}

\titlespacing*{\chapter}{0pt}{-6mm}{0.8\baselineskip}
\titlespacing*{\section}{0pt}{1.0\baselineskip}{0.3\baselineskip}
\titlespacing*{\subsection}{0pt}{0.7\baselineskip}{0.2\baselineskip}

\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}
\NoahInstallTitleCasing

\let\noah@original@chapter\chapter
\RenewDocumentCommand{\chapter}{s o m}{%
  \IfBooleanTF{#1}
    {\noah@original@chapter*{\NoahTitleCase{#3}}}
    {\IfNoValueTF{#2}
      {\noah@original@chapter{\NoahTitleCase{#3}}}
      {\noah@original@chapter[\NoahTitleCase{#2}]{\NoahTitleCase{#3}}}}%
}

\renewcommand{\cftchapfont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftchappagefont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsecfont}{\sffamily\color{AUblue}}
\renewcommand{\cftsecpagefont}{\sffamily\color{AUblue}}
\renewcommand{\cftsubsecfont}{\sffamily\color{AUblueDark}}
\renewcommand{\cftsubsecpagefont}{\sffamily\color{AUblueDark}}
\renewcommand{\cftchapdotsep}{\cftdotsep}
\renewcommand{\cftloftitlefont}{\Huge\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftlottitlefont}{\Huge\bfseries\sffamily\color{AUblueDark}}

% Align contents and list titles with ordinary chapter headings.
\setlength{\cftbeforetoctitleskip}{3mm}
\setlength{\cftaftertoctitleskip}{-3mm}

\setlength{\cftbeforeloftitleskip}{3mm}
\setlength{\cftafterloftitleskip}{1.3\baselineskip}

\setlength{\cftbeforelottitleskip}{3mm}
\setlength{\cftafterlottitleskip}{1.3\baselineskip}

% Running headers and page styles
\renewcommand{\chaptermark}[1]{\markboth{\NoahTitleCase{#1}}{}}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrule}{\hbox to\headwidth{\color{AUblueDark}\leaders\hrule height 0.4pt\hfill}}

\if@twoside
  \fancyhead[LE]{\footnotesize\sffamily\color{AUblueDark}\thepage}
  \fancyhead[RE]{\scriptsize\sffamily\color{AUblueDark}\NoahRunningTitle}
  \fancyhead[LO]{\scriptsize\sffamily\color{AUblue}\nouppercase{\leftmark}}
  \fancyhead[RO]{\footnotesize\sffamily\color{AUblueDark}\thepage}
\else
  \fancyhead[L]{\scriptsize\sffamily\color{AUblueDark}\NoahRunningTitle}
  \fancyhead[R]{\scriptsize\sffamily\color{AUblue}\nouppercase{\leftmark}}
  \fancyfoot[C]{\small\sffamily\color{AUblueDark}\thepage}
\fi

\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyhead[L]{\scriptsize\sffamily\color{AUblueDark}\NoahRunningTitle}
  \fancyhead[R]{\scriptsize\sffamily\color{AUblue}\nouppercase{\leftmark}}
  \fancyfoot[C]{\small\sffamily\color{AUblueDark}\thepage}
  \renewcommand{\headrule}{%
    \hbox to\headwidth{%
      \color{AUblueDark}\leaders\hrule height 0.4pt\hfill}}
}

% Project title page
\renewcommand{\maketitle}{%
  \hypersetup{pageanchor=false}%
  \begin{titlepage}
    \NoahTitleStripe
    \thispagestyle{empty}

    \vspace*{7mm}

    {\large\bfseries\sffamily\NoahDepartment\par}
    {\normalsize\sffamily\NoahUniversity\par}

    \vspace{24mm}

    {\fontsize{30pt}{33pt}\selectfont
      \bfseries\sffamily\raggedright
      \ReportTitle\par}

    \vspace{10mm}

    {\color{AUblueDark}\rule{\linewidth}{1.4pt}}

    \vspace{8mm}

    \begingroup
    \setstretch{1.05}
    \begin{tabularx}{\linewidth}
      {@{}>{\raggedright\arraybackslash}p{38mm}X@{}}
      \NoahProjectAuthorRows
      \NoahProjectCourseMetadataRow
      \NoahSupervisorMetadataRow
      \NoahSemesterMetadataRow
      \NoahSubmissionMetadataRow
    \end{tabularx}
    \endgroup

    \vfill

    \begin{flushright}
      \NoahIncludeLogo{42mm}
    \end{flushright}
  \end{titlepage}%

  \ifnoah@infrontmatter
    \setcounter{page}{2}
  \fi

  \hypersetup{pageanchor=true}%
}

% Front matter
\renewenvironment{abstract}
  {\chapter*{\abstractname}%
   \addcontentsline{toc}{chapter}{\abstractname}%
   \chaptermark{\abstractname}}
  {\par}

\newenvironment{preface}
  {\chapter*{Preface}%
   \addcontentsline{toc}{chapter}{Preface}%
   \chaptermark{Preface}}
  {\clearpage}

\newcommand{\printreferences}{%
  \printbibliography[heading=bibintoc,title={References}]%
}

% IEEE-style cross-reference name
\crefname{appendix}{appendix}{appendices}
\Crefname{appendix}{Appendix}{Appendices}
\crefname{figure}{Fig.}{Figs.}
\Crefname{figure}{Fig.}{Figs.}

\let\noah@original@appendix\appendix
\renewcommand{\appendix}{%
  \noah@original@appendix
  \crefalias{chapter}{appendix}%
}

\newcommand{\printlistoffigures}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\listfigurename}%
  \listoffigures
}

\newcommand{\printlistoftables}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\listtablename}%
  \listoftables
}

\sisetup{per-mode=symbol}

\captionsetup[figure]{%
  name=Fig.,
  labelsep=period
}

% IEEE bibliography configuration
\AtEveryBibitem{%
  \clearfield{pagetotal}%
  \clearfield{isbn}%
  \clearfield{issn}%
}

\DeclareBibliographyDriver{standard}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \printfield{title}%
  \newunit\newblock
  \printfield{number}%
  \newunit\newblock
  \printlist{publisher}%
  \newunit\newblock
  \printlist{location}%
  \newunit\newblock
  \printdate%
  \newunit\newblock
  \usebibmacro{url+urldate}%
  \newunit\newblock
  \printfield{note}%
  \usebibmacro{finentry}%
}
