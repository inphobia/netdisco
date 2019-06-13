creating css files for bootstrap+netdisco from scss sources

overrides go in custom.scss, then generate a netdisco.css file with the following command:
sass --no-source-map custom.scss netdisco.css
(needs node.js & sass installed)

this will generate a complete replacement for bootstrap's css file.

see:
https://getbootstrap.com/docs/4.3/getting-started/theming/
https://uxplanet.org/how-to-customize-bootstrap-b8078a011203

bootstrap dir should in ideal case be a reference to bootstrap github repo (don't forget to tag version 4.3.1)
for now we just copied the files.