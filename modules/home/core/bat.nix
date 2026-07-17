{
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.bat = {
            enable = true;
            config.theme = "kanso-zen";
            syntaxes.php-inline = {
                src = pkgs.writeTextDir "PHP-Inline.sublime-syntax" ''
                    %YAML 1.2
                    ---
                    name: PHP Inline
                    file_extensions:
                      - php
                    scope: source.php.inline
                    contexts:
                      main:
                        - include: scope:source.php
                '';
                file = "PHP-Inline.sublime-syntax";
            };
            themes.kanso-zen = {
                src = pkgs.writeTextDir "kanso-zen.tmTheme" ''
                    <?xml version="1.0" encoding="UTF-8"?>
                    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                    <plist version="1.0">
                    <dict>
                    	<key>name</key>
                    	<string>Kanso Zen</string>
                    	<key>settings</key>
                    	<array>
                    		<dict>
                    			<key>settings</key>
                    			<dict>
                    				<key>background</key>
                    				<string>#090E13</string>
                    				<key>foreground</key>
                    				<string>#C5C9C7</string>
                    				<key>caret</key>
                    				<string>#F2F1EF</string>
                    				<key>invisibles</key>
                    				<string>#5C6066</string>
                    				<key>lineHighlight</key>
                    				<string>#1C1E25</string>
                    				<key>selection</key>
                    				<string>#393B44</string>
                    				<key>selectionForeground</key>
                    				<string>#F2F1EF</string>
                    				<key>findHighlight</key>
                    				<string>#2D4F67</string>
                    				<key>findHighlightForeground</key>
                    				<string>#F2F1EF</string>
                    				<key>gutter</key>
                    				<string>#090E13</string>
                    				<key>gutterForeground</key>
                    				<string>#5C6066</string>
                    				<key>selectionBorder</key>
                    				<string>#223249</string>
                    				<key>activeGuide</key>
                    				<string>#393B44</string>
                    				<key>guide</key>
                    				<string>#22262D</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Comment</string>
                    			<key>scope</key>
                    			<string>comment, punctuation.definition.comment</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>italic</string>
                    				<key>foreground</key>
                    				<string>#75797F</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>String</string>
                    			<key>scope</key>
                    			<string>string, string.quoted, string.template, string.unquoted</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#8A9A7B</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>String escape / regex</string>
                    			<key>scope</key>
                    			<string>constant.character.escape, string.regexp</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#C4746E</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Number</string>
                    			<key>scope</key>
                    			<string>constant.numeric</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#A292A3</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Constant / language constant</string>
                    			<key>scope</key>
                    			<string>constant.language, constant.character, constant.other, support.constant</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#B6927B</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Variable</string>
                    			<key>scope</key>
                    			<string>variable, variable.other, variable.language, variable.other.readwrite</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#C5C9C7</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Parameter / property</string>
                    			<key>scope</key>
                    			<string>variable.parameter, variable.other.member, variable.other.property, variable.other.object.property</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#909398</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Keyword / storage / statement</string>
                    			<key>scope</key>
                    			<string>keyword, keyword.control, keyword.operator.word, storage, storage.type, storage.modifier</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>italic</string>
                    				<key>foreground</key>
                    				<string>#8992A7</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Operator / punctuation</string>
                    			<key>scope</key>
                    			<string>keyword.operator, punctuation, punctuation.separator, punctuation.terminator, punctuation.accessor, meta.brace</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#909398</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Preprocessor / annotation</string>
                    			<key>scope</key>
                    			<string>keyword.control.import, keyword.control.export, meta.preprocessor, punctuation.definition.annotation, storage.type.annotation</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#909398</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Function / method</string>
                    			<key>scope</key>
                    			<string>entity.name.function, support.function, meta.function-call</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#8BA4B0</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Type / class</string>
                    			<key>scope</key>
                    			<string>entity.name.type, entity.name.class, entity.other.inherited-class, support.type, support.class, storage.type.class</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#8EA4A2</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Tag</string>
                    			<key>scope</key>
                    			<string>entity.name.tag, meta.tag</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#C4746E</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Attribute name</string>
                    			<key>scope</key>
                    			<string>entity.other.attribute-name</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#C4B28A</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Identifier / special1</string>
                    			<key>scope</key>
                    			<string>variable.function, entity.name, support.other</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#8992A7</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Deprecated / invalid</string>
                    			<key>scope</key>
                    			<string>invalid, invalid.deprecated</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>underline italic</string>
                    				<key>foreground</key>
                    				<string>#717C7C</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Invalid illegal</string>
                    			<key>scope</key>
                    			<string>invalid.illegal</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>background</key>
                    				<string>#43242B</string>
                    				<key>foreground</key>
                    				<string>#C34043</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Diff header</string>
                    			<key>scope</key>
                    			<string>meta.diff, meta.diff.header</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#75797F</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Diff deleted / markup deleted</string>
                    			<key>scope</key>
                    			<string>markup.deleted, meta.diff.header.from-file</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>background</key>
                    				<string>#43242B</string>
                    				<key>foreground</key>
                    				<string>#E46876</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Diff inserted / markup inserted</string>
                    			<key>scope</key>
                    			<string>markup.inserted, meta.diff.header.to-file</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>background</key>
                    				<string>#2B3328</string>
                    				<key>foreground</key>
                    				<string>#87A987</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Diff changed / markup changed</string>
                    			<key>scope</key>
                    			<string>markup.changed</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>background</key>
                    				<string>#49443C</string>
                    				<key>foreground</key>
                    				<string>#E6C384</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Markup heading</string>
                    			<key>scope</key>
                    			<string>markup.heading</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>bold</string>
                    				<key>foreground</key>
                    				<string>#8BA4B0</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Markup bold</string>
                    			<key>scope</key>
                    			<string>markup.bold</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>bold</string>
                    				<key>foreground</key>
                    				<string>#F2F1EF</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Markup italic</string>
                    			<key>scope</key>
                    			<string>markup.italic</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>italic</string>
                    				<key>foreground</key>
                    				<string>#8992A7</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Markup link</string>
                    			<key>scope</key>
                    			<string>markup.underline.link, string.other.link</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>underline</string>
                    				<key>foreground</key>
                    				<string>#7FB4CA</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Markup quote</string>
                    			<key>scope</key>
                    			<string>markup.quote</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>fontStyle</key>
                    				<string>italic</string>
                    				<key>foreground</key>
                    				<string>#75797F</string>
                    			</dict>
                    		</dict>
                    		<dict>
                    			<key>name</key>
                    			<string>Markup raw / code block</string>
                    			<key>scope</key>
                    			<string>markup.raw, markup.inline.raw</string>
                    			<key>settings</key>
                    			<dict>
                    				<key>foreground</key>
                    				<string>#C4B28A</string>
                    			</dict>
                    		</dict>
                    	</array>
                    	<key>uuid</key>
                    	<string>7c2b1a4e-3f9d-4a6b-9c2e-6b9a1d5e0f21</string>
                    </dict>
                    </plist>
                '';
                file = "kanso-zen.tmTheme";
            };
        };
    };
}
