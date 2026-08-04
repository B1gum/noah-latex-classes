\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{noahnotes}[2026/08/04 Noah's lecture-notes class]

% ---------------------------------------------------------------------------
% Deliberately small, curated option surface
% ---------------------------------------------------------------------------
\newif\ifnoah@assignment \noah@assignmentfalse
\newif\ifnoah@notes      \noah@notestrue
\newif\ifnoah@danish     \noah@danishfalse
\newif\ifnoah@anonymous  \noah@anonymousfalse
\newif\ifnoah@draft      \noah@draftfalse
\newif\ifnoah@print      \noah@printfalse
\newif\ifnoah@class@twoside \noah@class@twosidefalse
\def\noah@language{english}

\DeclareOption{english}{\def\noah@language{english}\noah@danishfalse}
\DeclareOption{danish}{\def\noah@language{danish}\noah@danishtrue}
\DeclareOption{draft}{\noah@drafttrue}
\DeclareOption{final}{\noah@draftfalse}
\DeclareOption{print}{\noah@printtrue}
\DeclareOption{screen}{\noah@printfalse}
\DeclareOption{twoside}{\noah@class@twosidetrue}
\DeclareOption{oneside}{\noah@class@twosidefalse}
\DeclareOption*{\ClassError{noahnotes}{Unknown option `\CurrentOption'}{Allowed options: english, danish, draft, final, print, screen, twoside, oneside.}}
\ProcessOptions\relax

\ifnoah@class@twoside
  \LoadClass[11pt,a4paper,twoside]{article}
\else
  \LoadClass[11pt,a4paper,oneside]{article}
\fi
\RequirePackage{noah-common}
\RequirePackage{titlesec}
\RequirePackage{needspace}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}

% Notes layout
\geometry{a4paper,top=23mm,bottom=24mm,left=24mm,right=24mm,headheight=30pt,headsep=7mm,footskip=12mm}

\setstretch{1.15}

\setlength{\parskip}{0.48\baselineskip plus 1pt minus 1pt}

% Captions
\NoahConfigureListsAndCaptions{3pt}{1.5pt}{false}

% Links
\ifnoah@print
  \hypersetup{hidelinks}
\else
  \hypersetup{colorlinks=true,linkcolor=AUblueDark,urlcolor=AUblueDark,citecolor=AUblueDark}
\fi

% ---------------------------------------------------------------------------
% Headings
% ---------------------------------------------------------------------------
\titleformat{\section}
  {\Large\bfseries\sffamily\color{AUblueDark}}
  {\thesection}{0.75em}{}
\titleformat{\subsection}
  {\large\bfseries\sffamily\color{AUblue}}
  {\thesubsection}{0.65em}{}
\titleformat{\subsubsection}
  {\normalsize\bfseries\sffamily\color{AUblueDark}}
  {\thesubsubsection}{0.55em}{}
\titlespacing*{\section}{0pt}{1.25\baselineskip}{0.4\baselineskip}
\titlespacing*{\subsection}{0pt}{0.9\baselineskip}{0.25\baselineskip}
\titlespacing*{\subsubsection}{0pt}{0.7\baselineskip}{0.15\baselineskip}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\NoahInstallTitleCasing

% Make contents entries visually echo the corresponding in-text headings.
\renewcommand{\cftsecfont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsecpagefont}{\bfseries\sffamily\color{AUblueDark}}
\renewcommand{\cftsubsecfont}{\sffamily\color{AUblue}}
\renewcommand{\cftsubsecpagefont}{\sffamily\color{AUblue}}
\renewcommand{\cftsubsubsecfont}{\sffamily\color{AUblueDark}}
\renewcommand{\cftsubsubsecpagefont}{\sffamily\color{AUblueDark}}
\renewcommand{\cftsecdotsep}{\cftdotsep}

% ---------------------------------------------------------------------------
% Lecture-aware running headers
% ---------------------------------------------------------------------------
\newcommand{\noah@currentnav}{\ReportTitle}
\newcommand{\noah@currentnavrunning}{\NoahRunningTitle}
\newif\ifnoah@lectureactive
\noah@lectureactivefalse

% When no lecture has been declared, ordinary section marks supply navigation.
\renewcommand{\sectionmark}[1]{%
  \ifnoah@lectureactive\else
    \gdef\noah@currentnav{\NoahTitleCase{#1}}%
    \global\let\noah@currentnavrunning\noah@currentnav
    \markright{\noah@currentnavrunning}%
  \fi
}
\AtBeginDocument{\markright{\NoahRunningTitle}}

\newcommand{\NoahNotesRunningHead}{%
  \makebox[\headwidth][c]{%
    \begin{minipage}[t]{0.48\headwidth}
      \raggedright\scriptsize\sffamily\color{AUblueDark}\NoahCourseShortName
    \end{minipage}\hfill
    \begin{minipage}[t]{0.48\headwidth}
      \raggedleft\scriptsize\sffamily\color{AUblue}\NoahPrimaryAuthorShort
    \end{minipage}%
  }%
}
\newcommand{\NoahNotesTwosideEvenHead}{%
  \makebox[\headwidth][c]{%
    \begin{minipage}[t]{0.12\headwidth}
      \raggedright\footnotesize\sffamily\color{AUblueDark}\thepage
    \end{minipage}\hfill
    \begin{minipage}[t]{0.40\headwidth}
      \centering\scriptsize\sffamily\color{AUblue}\NoahPrimaryAuthorShort
    \end{minipage}\hfill
    \begin{minipage}[t]{0.40\headwidth}
      \raggedleft\scriptsize\sffamily\color{AUblueDark}\NoahCourseShortName
    \end{minipage}%
  }%
}
\newcommand{\NoahNotesTwosideOddHead}{%
  \makebox[\headwidth][c]{%
    \begin{minipage}[t]{0.40\headwidth}
      \raggedright\scriptsize\sffamily\color{AUblueDark}\NoahCourseShortName
    \end{minipage}\hfill
    \begin{minipage}[t]{0.40\headwidth}
      \centering\scriptsize\sffamily\color{AUblue}\NoahPrimaryAuthorShort
    \end{minipage}\hfill
    \begin{minipage}[t]{0.12\headwidth}
      \raggedleft\footnotesize\sffamily\color{AUblueDark}\thepage
    \end{minipage}%
  }%
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrule}{\hbox to\headwidth{\color{AUblueDark}\leaders\hrule height 0.4pt\hfill}}
\renewcommand{\footrulewidth}{0pt}
\if@twoside
  % Mirror course, abbreviated author, and page number across each spread.
  \fancyhead[CE]{\NoahNotesTwosideEvenHead}
  \fancyhead[CO]{\NoahNotesTwosideOddHead}
\else
  % Fixed-width blocks allow long marks to wrap instead of overlap.
  \fancyhead[C]{\NoahNotesRunningHead}
  \fancyfoot[C]{\small\sffamily\color{AUblueDark}\thepage}
\fi

% ---------------------------------------------------------------------------
% Notes title page
% ---------------------------------------------------------------------------
\renewcommand{\maketitle}{%
  \hypersetup{pageanchor=false}%
  \begin{titlepage}
    \NoahTitleStripe
    \thispagestyle{empty}
    \vspace*{7mm}
    {\large\bfseries\sffamily\NoahDepartment\par}
    {\normalsize\sffamily\NoahUniversity\par}
    \vspace{24mm}
    {\fontsize{30pt}{33pt}\selectfont\bfseries\sffamily\raggedright\ReportTitle\par}
    \vspace{10mm}
    {\color{AUblueDark}\rule{\linewidth}{1.4pt}}
    \vspace{8mm}
    \begingroup
    \setstretch{1.05}
    \begin{tabularx}{\dimexpr\linewidth-2pt\relax}{@{}>{\raggedright\arraybackslash}p{38mm}X@{}}
      \NoahNotesAuthorRows
      \NoahCourseMetadataRow
      \NoahInstructorMetadataRow
      \NoahSemesterMetadataRow
      \NoahMetadataRow{\NoahLabelDate}{\@date}
    \end{tabularx}
    \endgroup
    \vfill
    \begin{flushright}\NoahIncludeLogo{32mm}\end{flushright}
  \end{titlepage}%
  \ifnoah@infrontmatter\setcounter{page}{2}\fi
  \hypersetup{pageanchor=true}%
}

\AtBeginDocument{%
  \NoahIfBlankTF{\@title}
    {\ClassWarning{noahnotes}{No title has been set}}
    {}
}

% ---------------------------------------------------------------------------
% Manual lecture identifiers and custom contents entries
% ---------------------------------------------------------------------------
\newcounter{lecture}
\ifnoah@danish
  \crefname{lecture}{forelæsning}{forelæsninger}
  \Crefname{lecture}{Forelæsning}{Forelæsninger}
\else
  \crefname{lecture}{lecture}{lectures}
  \Crefname{lecture}{Lecture}{Lectures}
\fi

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

% Optional short navigation title retained for custom page styles
\NewDocumentCommand{\lecture}{O{} m m m}{%
  \refstepcounter{lecture}% unique hyperlink anchor
  \protected@edef\@currentlabel{#2}% manual visible identifier
  \NoahStoreTitleCase{\noah@lecturetitle}{#4}%
  \ifstrempty{#1}
    {\let\noah@lectureshort\noah@lecturetitle}
    {\NoahStoreTitleCase{\noah@lectureshort}{#1}}%
  \protected@edef\@currentlabelname{\noah@lecturetitle}%
  \global\noah@lectureactivetrue
  \ifstrempty{#4}
    {\gdef\noah@currentnav{\NoahLabelLecture~#2}}
    {\protected@xdef\noah@currentnav{\NoahLabelLecture~#2: \noah@lecturetitle}}%
  \ifstrempty{#1}
    {\global\let\noah@currentnavrunning\noah@currentnav}
    {\protected@xdef\noah@currentnavrunning{\NoahLabelLecture~#2: \noah@lectureshort}}%
  \markright{\noah@currentnavrunning}%
  \Needspace{4\baselineskip}
  \par\vspace{0.8\baselineskip}
  \noindent
  \begin{minipage}[t]{0.78\linewidth}
    \raggedright\normalsize\sffamily\color{black}\noah@currentnav
  \end{minipage}\hfill
  \begin{minipage}[t]{0.18\linewidth}
    \raggedleft\small\sffamily\color{AUblue}#3
  \end{minipage}%
  \par\vspace{0.2\baselineskip}
  \addcontentsline{toc}{lecture}{\noah@currentnav}%
}

% Figures and tables are numbered within sections.
\counterwithin{figure}{section}
\counterwithin{table}{section}

% ---------------------------------------------------------------------------
% Numbered formal boxes
% ---------------------------------------------------------------------------
\newcounter{definition}[section]
\newcounter{example}[section]
\newcounter{theorem}[section]
\renewcommand{\thedefinition}{\thesection.\arabic{definition}}
\renewcommand{\theexample}{\thesection.\arabic{example}}
\renewcommand{\thetheorem}{\thesection.\arabic{theorem}}

\ifnoah@danish
  \crefname{definition}{definition}{definitioner}
  \Crefname{definition}{Definition}{Definitioner}
  \crefname{example}{eksempel}{eksempler}
  \Crefname{example}{Eksempel}{Eksempler}
  \crefname{theorem}{sætning}{sætninger}
  \Crefname{theorem}{Sætning}{Sætninger}
\else
  \crefname{definition}{definition}{definitions}
  \Crefname{definition}{Definition}{Definitions}
  \crefname{example}{example}{examples}
  \Crefname{example}{Example}{Examples}
  \crefname{theorem}{theorem}{theorems}
  \Crefname{theorem}{Theorem}{Theorems}
\fi

\newcommand{\noah@boxtitle}[3]{#1~#2\ifstrempty{#3}{}{: #3}}

\NewDocumentEnvironment{definition}{O{}}{%
  \Needspace{7\baselineskip}
  \refstepcounter{definition}
  \def\@currentlabelname{#1}
  \begin{tcolorbox}[
    enhanced,sharp corners,frame hidden,boxrule=0pt,
    colback=AUgreen!7,colbacktitle=AUgreen!25,coltitle=AUgreenDark,
    borderline west={2pt}{0pt}{AUgreen},
    left=10pt,right=10pt,top=8pt,bottom=8pt,
    fonttitle=\bfseries\sffamily,
    title={\noah@boxtitle{\NoahLabelDefinition}{\thedefinition}{#1}},
    before skip=9pt,after skip=9pt
  ]
}{\end{tcolorbox}}

\NewDocumentEnvironment{exa}{O{}}{%
  \refstepcounter{example}
  \def\@currentlabelname{#1}
  \begin{tcolorbox}[
    enhanced,sharp corners,breakable,frame hidden,boxrule=0pt,
    colback=AUorange!5,colbacktitle=AUorange!18,coltitle=AUorangeDark,
    borderline west={2pt}{0pt}{AUorange},
    left=9pt,right=9pt,top=7pt,bottom=7pt,
    fonttitle=\bfseries\sffamily,
    title={\noah@boxtitle{\NoahLabelExample}{\theexample}{#1}},
    before skip=8pt,after skip=8pt
  ]
}{\end{tcolorbox}}

\newcommand{\proofpart}{%
  \tcblower
  {\bfseries\sffamily\NoahLabelProof.}\par\smallskip
}

\NewDocumentEnvironment{sæt}{O{}}{%
  \Needspace{7\baselineskip}
  \refstepcounter{theorem}
  \def\@currentlabelname{#1}
  \begin{tcolorbox}[
    enhanced,sharp corners,breakable,frame hidden,boxrule=0pt,
    colback=AUpurple!7,colbacktitle=AUpurple!25,coltitle=AUpurpleDark,
    colbacklower=AUpurple!7,
    segmentation style={solid,line width=0.5pt,draw=AUpurple!55},
    borderline west={2pt}{0pt}{AUpurple},
    left=10pt,right=10pt,top=8pt,bottom=8pt,
    fonttitle=\bfseries\sffamily,
    title={\noah@boxtitle{\NoahLabelTheorem}{\thetheorem}{#1}},
    before skip=9pt,after skip=9pt
  ]
}{\end{tcolorbox}}
