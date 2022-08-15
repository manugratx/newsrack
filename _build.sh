# change .recipe.py files to .recipe
for f in recipes/*.recipe.py; do
    b="$(basename -- $f)"
    cp -p "$f" "${b%.py}"
done
# for forks
if [ -n "$(ls -A recipes_custom/*.recipe.py 2>/dev/null)" ]
then
  for f in recipes_custom/*.recipe.py; do
      b="$(basename -- $f)"
      cp -p "$f" "${b%.py}"
  done
fi

mkdir -p public cache \
&& cp -p static/*.svg public/ \
&& sass -s compressed --no-source-map static/site.scss static/site.css \
&& sass -s compressed --no-source-map static/nonkindle.scss static/nonkindle.css \
&& python3 _generate.py "$CI_PAGES_URL" \
&& html-minifier-terser --input-dir public/ --output-dir public/ --minify-js --collapse-whitespace --file-ext html \
&& rm -f *.recipe
