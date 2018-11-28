%%
%% Homework document class
%%
%% Author: Delta Dak
%% Version: 1.1
%% Date: 2017-09-14
%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{homework}[2017/09/14 Version 1.1 Homework document class by Delta Dak]

%
% Key-value options
%  - language: `dutch' by default. Only `dutch' and `english' are really supported.
%  - number: `1' by default. The (week) number of this homework instance.
%
% Boolean switches
%  - fleqn: `true' by default. Floats equations to the left.
%

%
% Changelog
%
% Version 1.1 :: 2017-09-14
%  - Fixed issues with \let and \newcommand.
%  - Modified some command definitions to a TeXiFy-friendly format.
%  - Added \Var command for variance in probability theory.
%  - Moved \firstquestion definition into cls, for cleaner documents.
%
% Version 1.0 :: 2017-09-13
%  - Normalized to first version.
%

\LoadClass[a4paper]{exam}

% Process options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=hw, prefix=hw@}

\DeclareStringOption[dutch]{language}
\DeclareBoolOption[true]{fleqn}
\DeclareStringOption[1]{number}

\ProcessKeyvalOptions*

% Load packages
\RequirePackage[\hw@language]{babel}
\RequirePackage[\ifhw@fleqn fleqn\fi]{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{stmaryrd}
\RequirePackage{amsfonts}
\RequirePackage{etoolbox}
\RequirePackage{enumerate}
\RequirePackage{scalerel}
\RequirePackage{stackengine}
\RequirePackage{xifthen}
\RequirePackage{lmodern}
\RequirePackage{gensymb}
\RequirePackage{color}
\RequirePackage{colortbl}
\RequirePackage{needspace}
\RequirePackage{enumitem}
\RequirePackage{mathtools}


%
% Page layout
%

% Course name for document title
\newcommand{\coursename}[1]{\renewcommand{\hw@coursename}{#1}}
\newcommand\hw@coursename{}

% Author names
\newcommand{\authors}[1]{\renewcommand{\hw@author}{#1}}
\newcommand\hw@author{}

% Group name (if applicable)
\newcommand{\groupname}[1]{\renewcommand{\hw@group}{#1}}
\newcommand\hw@group{}


% Sets title page and footer
\footer{}{}{}
\date{\today}
\title{\textbf{\hw@coursename}\\\expandafter\ifstrequal\expandafter{\hw@language}{dutch}{Samenvatting}{Summary}~\hw@number}%
\author{\ifstrempty{\hw@group}{}{\textbf{\hw@group}\\}\hw@author}%

% Create the title page
\newcommand{\maketitlepage}{%
    \maketitle%
    \thispagestyle{empty}%
    \newpage%
}


% Set smaller margins
\setlength{\oddsidemargin}{0in}
\setlength{\evensidemargin}{0in}
\setlength{\topmargin}{0in}
\setlength{\headsep}{-.25in}
\setlength{\textwidth}{6.5in}
\setlength{\textheight}{8.5in}

\setlength{\parindent}{1cm}


% Equation labels per question
\numberwithin{equation}{question}

% Question spacing
\let\old@questions\questions
\let\old@endquestions\endquestions
\renewenvironment{questions}{%
    \old@questions%
    \let\firstquestion\question%
    \renewcommand*{\question}{\vspace{7mm}\firstquestion}%
}{\old@endquestions}


%
% Redefinitions of standard commands
%

% Q.E.D.
\renewcommand{\qedsymbol}{\footnotesize$\boxempty$ \textsc{q.\,e.\,d.}}

% \\ Shall not be used when not in a split environment or table (use a blank line)
\newcommand\old@break{\\}
\renewcommand*{\\}{\ifmmode \old@break \else $\boxed{\hat{\delta}}$ \fi}

% Dfrac shall not be used (except for extreme cases, work around it yourself)
\renewcommand{\dfrac}[2]{\frac{#1}{#2}}

% Better phi
\newcommand\hw@temp{\phi}
\let\phi\varphi
\let\varphi\hw@temp

% Better epsilon
\renewcommand\hw@temp{\epsilon}
\let\epsilon\varepsilon
\let\varepsilon\hw@temp

% Better empty set
\let\oldemptyset\emptyset
\let\emptyset\varnothing

% Paragraphs have a line break after the title
\newcommand{\oldparagraph}{\paragraph}
\renewcommand*{\paragraph}[1]{\oldparagraph{#1}\mbox{}\oldbreak}

% lange and rangle scale automatically
\let\oldlangle\langle
\renewcommand{\langle}{\left\oldlangle}

\let\oldrangle\rangle
\renewcommand{\rangle}{\right\oldrangle}


%
% Custom commands and environments
%

%%% General

% To prove environment
\theoremstyle{definition}
\newtheorem*{toprove}{\expandafter\ifstrequal\expandafter{\hw@language}{dutch}{Te bewijzen}{To prove}}

%define definition environment
\theoremstyle{definition}
\newtheorem{definition}{Definition}[section]

\theoremstyle{theorem}
\newtheorem{theorem}{Theorem}[section]

% Inline to prove env. To be used when `toprove' is the first content in a question.
% Then normally the text would end up on a new line, which is ugly. In these cases, use this environment instead.
\newenvironment{inlinetoprove}{%
    \enskip\textbf{\expandafter\ifstrequal\expandafter{\hw@language}{dutch}{Te bewijzen}{To prove}.\space}%
}{\enskip}

% Question group header
\newcommand{\questiongroup}[1]{\fullwidth{\Large \textbf{#1}}}

% Internal helper commands
\DeclarePairedDelimiter{\paren}\lparen\rparen
\DeclarePairedDelimiter{\brackets}\lbrack\rbrack

\patchcmd\g@matrix
{\vbox\bgroup}
{\vbox\bgroup\normalbaselines}% restore the standard baselineskip
{}{}

\newcommand*{\da@rightarrow}{\mathchar"0\hexnumber@\symAMSa 4B }
\newcommand*{\da@leftarrow}{\mathchar"0\hexnumber@\symAMSa 4C }
\newcommand*{\xdashrightarrow}[2][]{%
\mathrel{%
\mathpalette{\da@xarrow{#1}{#2}{}\da@rightarrow{\,}{}}{}%
}%
}
\newcommand{\xdashleftarrow}[2][]{%
\mathrel{%
\mathpalette{\da@xarrow{#1}{#2}\da@leftarrow{}{}{\,}}{}%
}%
}
\newcommand*{\da@xarrow}[7]{%
% #1: below
% #2: above
% #3: arrow left
% #4: arrow right
% #5: space left
% #6: space right
% #7: math style
\sbox0{$\ifx#7\scriptstyle\scriptscriptstyle\else\scriptstyle\fi#5#1#6\m@th$}%
\sbox2{$\ifx#7\scriptstyle\scriptscriptstyle\else\scriptstyle\fi#5#2#6\m@th$}%
\sbox4{$#7\dabar@\m@th$}%
\dimen@=\wd0 %
\ifdim\wd2 >\dimen@
\dimen@=\wd2 %
\fi
\count@=2 %
\def\da@bars{\dabar@\dabar@}%
\@whiledim\count@\wd4<\dimen@\do{%
\advance\count@\@ne
\expandafter\def\expandafter\da@bars\expandafter{%
\da@bars
\dabar@
}%
}%
\mathrel{#3}%
\mathrel{%
\mathop{\da@bars}\limits
\ifx\\#1\\%
\else
_{\copy0}%
\fi
\ifx\\#2\\%
\else
^{\copy2}%
\fi
}%
\mathrel{#4}%
}

\renewcommand*\env@matrix[1][*\c@MaxMatrixCols c]{%
\hskip -\arraycolsep
\let\@ifnextchar\new@ifnextchar
\array{#1}}


%%% Sets and constants

% Number sets
\newcommand{\naturals}{\mathbb{N}}
\newcommand{\integers}{\mathbb{Z}}
\newcommand{\reals}{\mathbb{R}}
\newcommand{\complex}{\mathbb{C}}
\newcommand{\rationals}{\mathbb{Q}}

% Upright constants
\newcommand{\ex}{\ensuremath{\mathrm{e}}}
\newcommand{\im}{\ensuremath{\mathrm{i}}}

% Interior
\DeclareMathOperator{\intr}{int}

% Set boundary
\newcommand{\bound}{\partial}

% \set command
\DeclarePairedDelimiterX{\set}[1]\lbrace\rbrace{\setaux #1||\endsetaux}
\def\setaux#1|#2|#3\endsetaux{\if\relax\detokenize{#2}\relax #1 \else #1 \;\delimsize\vert\; #2 \fi}

% Set complement
\newcommand{\scomp}[1]{#1^\mathsf{c}}


%%% Geometry

% Volume
\DeclareMathOperator{\Vol}{Vol}

% Distance
\DeclareMathOperator{\dist}{dist}


%%% Analysis

% Point-wise and uniform convergent
\newcommand{\pwto}[2][]{\xdashrightarrow[#1]{#2}}
\newcommand{\unito}[2][]{\xrightarrow[#1]{#2}}

% Infinity norm
\newcommand{\inftynorm}[1]{\left\|#1\right\|_\infty}

% Integral d
\renewcommand*{\d}{\mathop{}\!\mathrm{d}}

% Function restrictions
\newcommand{\restr}[2]{{
    \left.\kern-\nulldelimiterspace % automatically resize the bar with \right
    #1 % the function
    \vphantom{\big|} % pretend it's a little taller at normal size
    \right|_{#2} % this is the delimiter
}}


%%% Vectors and linear algebra

% Vectors
\renewcommand{\vec}[1]{\mathbf{#1}}

% (Vector) underline shortcut
\newcommand{\ul}[1]{\underline{#1}}

% Linear maps
\newcommand{\lmap}[1]{\mathcal{#1}}

% Vertical vector
\newcommand{\vvec}[1]{\begin{pmatrix} #1 \end{pmatrix}}

% Transition matrix
\newcommand{\transmat}[3][S]{\ifthenelse{\isempty{#1}}{{}_{#3}S_{#2}}{{}_{#3}#1_{#2}}}

% Vertical bars in gmatrix
\newcommand{\BAR}{%
    \hspace{-\arraycolsep}%
    \strut\unskip\ \vrule \ % the `\vrule` is as high and deep as a strut
    \hspace{-\arraycolsep}%
}
\newcommand{\mbar}{\hspace{-\arraycolsep} \strut\vrule \hspace{-\arraycolsep}}


%%% Asymptotics

% Big-O notation
\newcommand{\bigO}{\mathcal O}


%%% Complex numbers

% Real and imaginary parts
\let\Re\relax
\DeclareMathOperator{\Re}{Re}
\let\Im\relax
\DeclareMathOperator{\Im}{Im}

% Conjecture
\newcommand{\conj}[1]{\ensuremath{\overline{#1}}}


%%% Probability theory

% Probability
\renewcommand{\P}[1]{\mathbb{P}\paren*{#1}}

% Expected value
\newcommand{\E}[1]{\mathbb{E}\brackets*{#1}}

% Indicator function
\newcommand{\I}{\mathbb{I}}

% Distributions
\DeclareMathOperator{\Exp}{Exp}
\DeclareMathOperator{\Geo}{Geo}

% Variance
\DeclareMathOperator{\Var}{Var}

\endinput
