# Replace lines containing <!-- thai -->
sed -i 's/<family>[^<]*<\/family> <!-- thai -->/<family>testest<\/family> <!-- thai -->/g' ./69-nonlatintest.conf
# Remove duplicate lines
awk '!seen[$0]++' path/to/your/file.xml > path/to/your/tempfile.xml && mv path/to/your/tempfile.xml path/to/your/file.xml