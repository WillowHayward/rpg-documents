\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rpgbook}[2025/08/09 Custom wrapper for dndbook]

\RequirePackage{rpgprint}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{dndbook}}
\ProcessOptions\relax

\LoadClass{dndbook}

