# Install and configure docsplit
# Luan Guimarães e Thalisson Barreto
# Oct 28 2016

# Remember to put docsplit gem @ app's Gemfile

necessary_packages = %w(graphicsmagick poppler-utils poppler-data ghostscript tesseract-ocr pdftk)

necessary_packages.each do | pkg |
  package pkg
end

# Install imagemagick
# Luan Guimarães
# Oct 29 2016

package 'imagemagick'
