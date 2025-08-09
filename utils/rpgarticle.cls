\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rpgarticle}[2025/08/09 Custom wrapper for dndarticle]

\RequirePackage{rpgprint}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{dndarticle}}
\ProcessOptions\relax

\LoadClass{dndarticle}

