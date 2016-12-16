package net.retrocade.retrocamel.display.flash {
	import flash.filters.DropShadowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import net.retrocade.retrocamel.core.retrocamel_int;

	use namespace retrocamel_int;

	public class RetrocamelTextField extends RetrocamelSprite {

		/******************************************************************************************************/
		/**                                                                                        VARIABLES  */
		/******************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Internals
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private var _textField:TextField = new TextField();

		/**
		 * Internal text format object
		 */
		private var _textFormat:TextFormat = new TextFormat();


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Color
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Indicates the color of the text. A number containing three 8-bit RGB components; for example, 0xFF0000 is
		 * red, and 0x00FF00 is green.
		 *
		 * @default null, which means that Flash Player uses the color black (0x000000)
		 */
		public function get color():uint {
			return uint(_textFormat.color);
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void {
			_textFormat.color = value;
			apply();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Display as Password
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Specifies whether the text field is a password text field. If the value of this property is true, the text
		 * field is treated as a password text field and hides the input characters using asterisks instead of the
		 * actual characters. If false, the text field is not treated as a password text field. When password mode is
		 * enabled, the Cut and Copy commands and their corresponding keyboard shortcuts will not function. This
		 * security mechanism prevents an unscrupulous user from using the shortcuts to discover a password on an
		 * unattended computer.
		 *
		 * @default false
		 */
		public function get displayAsPassword():Boolean {
			return _textField.displayAsPassword;
		}

		/**
		 * @private
		 */
		public function set displayAsPassword(value:Boolean):void {
			_textField.displayAsPassword = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Editable
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Whether this text can be edited. This property won't work if mouseEnabled or selectable are set to false,
		 * which is default.
		 */
		public function get editable():Boolean {
			return (_textField.type == TextFieldType.INPUT);
		}

		/**
		 * @private
		 */
		public function set editable(value:Boolean):void {
			_textField.type = (value ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Embed Fonts
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Specifies whether to render by using embedded font outlines. If false, Flash Player renders the text field
		 * by using device fonts.
		 *
		 * If you set the embedFonts property to true for a text field, you must specify a font for that text by using
		 * the font property of a TextFormat object applied to the text field. If the specified font is not embedded in
		 * the SWF file, the text is not displayed.
		 *
		 * @default true
		 */
		public function get embedFonts():Boolean {
			return _textField.embedFonts;
		}

		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void {
			_textField.embedFonts = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Font
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The name of the font for text in this text format, as a string.
		 *
		 * @default null, which means that Flash Player uses Times New Roman font for the text
		 */
		public function get font():String {
			return _textFormat.font;
		}

		/**
		 * @private
		 */
		public function set font(value:String):void {
			_textFormat.font = value;
			apply();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Height
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Height of the text field.
		 */
		override public function get height():Number {
			return _textField.height;
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void {
			_textField.height = value;
		}

		public function get $height():Number {
			return super.height;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: HTML Text
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Contains the HTML representation of the text field contents.
		 */
		public function get htmlText():String {
			return _textField.htmlText;
		}

		/**
		 * @private
		 */
		public function set htmlText(value:String):void {
			_textField.htmlText = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Length
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The number of characters in a text field. A character such as tab (\t) counts as one character.
		 */
		public function get length():int {
			return _textField.length;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Letter Spacing
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * A number representing the amount of space that is uniformly distributed between all characters. The value
		 * specifies the number of pixels that are added to the advance after each character.
		 * You can use decimal values such as 1.75.
		 *
		 * @default null, which means that 0 pixels of letter spacing is used
		 */
		public function get letterSpacing():Number {
			return Number(_textFormat.letterSpacing);
		}

		/**
		 * @private
		 */
		public function set letterSpacing(value:Number):void {
			_textFormat.letterSpacing = value;
			apply();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Line Space
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * An integer representing the amount of vertical space (called leading) between lines.
		 *
		 * @default null, which indicates that the amount of leading used is 0
		 */
		public function get lineSpacing():Number {
			return Number(_textFormat.leading);
		}

		/**
		 * @private
		 */
		public function set lineSpacing(value:Number):void {
			_textFormat.leading = value;
			apply();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Max Characters
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The maximum number of characters that the text field can contain, as entered by a user. A script can insert
		 * more text than maxChars allows; the maxChars property indicates only how much text a user can enter. If the
		 * value of this property is 0, a user can enter an unlimited amount of text.
		 *
		 * @default 0
		 */
		public function get maxChars():int {
			return _textField.maxChars;
		}

		/**
		 * @private
		 */
		public function set maxChars(value:int):void {
			_textField.maxChars = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Mouse Enabled
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Specifies whether this object receives mouse, or other user input, messages. The default value is false,
		 * which means that by default any InteractiveObject instance that is on the display list receives mouse events
		 * or other user input events. If mouseEnabled is set to false, the instance does not receive any mouse events
		 * (or other user input events like keyboard events). Any children of this instance on the display list are not
		 * affected. To change the mouseEnabled behavior for all children of an object on the display list, use
		 * flash.display.DisplayObjectContainer.mouseChildren.
		 *
		 * @default false
		 */
		override public function get mouseEnabled():Boolean {
			return super.mouseEnabled;
		}

		/**
		 * @private
		 */
		override public function set mouseEnabled(value:Boolean):void {
			super.mouseEnabled = _textField.mouseEnabled = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Multiline
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Indicates whether field is a multiline text field. If the value is true, the text field is multiline; if the
		 * value is false, the text field is a single-line text field. In a field of type TextFieldType.INPUT, the
		 * multiline value determines whether the Enter key creates a new line (a value of false, and the Enter key is
		 * ignored). If you paste text into a TextField with a multiline value of false, newlines are stripped out of
		 * the text.
		 *
		 * @default false
		 */
		public function get multiline():Boolean {
			return _textField.multiline;
		}

		/**
		 * @private
		 */
		public function set multiline(value:Boolean):void {
			_textField.multiline = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Number of Lines
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Defines the number of text lines in a multiline text field. If wordWrap property is set to true, the number
		 * of lines increases when text wraps.
		 */
		public function get numLines():int {
			return _textField.numLines;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Selectable
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * A Boolean value that indicates whether the text field is selectable. The value true indicates that the text
		 * is selectable. The selectable property controls whether a text field is selectable, not whether a text field
		 * is editable. A dynamic text field can be selectable even if it is not editable. If a dynamic text field is
		 * not selectable, the user cannot select its text.
		 *
		 * If selectable is set to false, the text in the text field does not respond to selection commands from the
		 * mouse or keyboard, and the text cannot be copied with the Copy command. If selectable is set to true, the
		 * text in the text field can be selected with the mouse or keyboard, and the text can be copied with the Copy
		 * command. You can select text this way even if the text field is a dynamic text field instead of an input text
		 * field.
		 *
		 * @default false
		 */
		public function get selectable():Boolean {
			return _textField.selectable;
		}

		/**
		 * @private
		 */
		public function set selectable(value:Boolean):void {
			_textField.selectable = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Size
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The size in pixels of text in this text format.
		 *
		 * @default null, which means that a size of 12 is used
		 */
		public function get size():Number {
			return Number(_textFormat.size);
		}

		/**
		 * @private
		 */
		public function set size(value:Number):void {
			_textFormat.size = value;
			apply();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Stylesheet
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Attaches a style sheet to the text field. For information on creating style sheets, see the StyleSheet class
		 * and the ActionScript 3.0 Developer's Guide.
		 *
		 * You can change the style sheet associated with a text field at any time. If you change the style sheet in
		 * use, the text field is redrawn with the new style sheet. You can set the style sheet to null or undefined to
		 * remove the style sheet. If the style sheet in use is removed, the text field is redrawn without a style
		 * sheet.
		 */
		public function get styleSheet():StyleSheet {
			return _textField.styleSheet;
		}

		/**
		 * @private
		 */
		public function set styleSheet(value:StyleSheet):void {
			_textField.styleSheet = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Text
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * A string that is the current text in the text field. Lines are separated by the carriage return character
		 * ('\r', ASCII 13). This property contains unformatted text in the text field, without HTML tags.
		 */
		public function get text():String {
			return _textField.text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void {
			_textField.text = value || "";
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Text Dimensions
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The height of the text in pixels.
		 */
		public function get textHeight():Number {
			return _textField.textHeight;
		}

		/**
		 * The width of the text in pixels.
		 */
		public function get textWidth():Number {
			return _textField.textWidth;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Width
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Width of the text field.
		 */
		override public function get width():Number {
			return _textField.width;
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void {
			_textField.width = value;
			_textField.x = 0;
		}

		public function get $width():Number {
			return super.width;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Word Wrap
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * A Boolean value that indicates whether the text field has word wrap. If the value of wordWrap is true, the
		 * text field has word wrap; if the value is false, the text field does not have word wrap.
		 *
		 * @default false
		 */
		public function get wordWrap():Boolean {
			return _textField.wordWrap;
		}

		/**
		 * @private
		 */
		public function set wordWrap(value:Boolean):void {
			_textField.wordWrap = value;
		}


		/******************************************************************************************************/
		/**                                                                                        FUNCTIONS  */
		/******************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Align
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Aligns the text to the left
		 */
		public function textAlignLeft():void {
			_textFormat.align = TextFormatAlign.LEFT;
			apply();
		}

		/**
		 * Aligns the text to the center
		 */
		public function textAlignCenter():void {
			_textFormat.align = TextFormatAlign.CENTER;
			apply();
		}

		/**
		 * Aligns the text to the right
		 */
		public function textAlignRight():void {
			_textFormat.align = TextFormatAlign.RIGHT;
			apply();
		}

		/**
		 * Aligns the text to be justified
		 */
		public function textAlignJustify():void {
			_textFormat.align = TextFormatAlign.JUSTIFY;
			apply();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Auto Size
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function autoSizeLeft():void {
			_textField.autoSize = TextFieldAutoSize.LEFT;
		}

		public function autoSizeCenter():void {
			_textField.autoSize = TextFieldAutoSize.CENTER;
		}

		public function autoSizeRight():void {
			_textField.autoSize = TextFieldAutoSize.RIGHT;
		}

		public function autoSizeNone():void {
			_textField.autoSize = TextFieldAutoSize.NONE;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Constructor
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function RetrocamelTextField(text:String = '', font:String = 'Pixelade', size:Number = 13, color:uint = 0xFFFFFF) {
			super();

			this.size = size;
			this.font = font;
			this.color = color;
			this.text = text;

			mouseEnabled = false;
			selectable = false;
			embedFonts = true;

			autoSizeLeft();

			_textField.setTextFormat(_textFormat);
			_textField.defaultTextFormat = _textFormat;

			addChild(_textField);
		}

		/**
		 * Forces text format to be applied to the text field
		 */
		public function apply():void {
			if (!_textField.styleSheet) {
				_textField.setTextFormat(_textFormat);
				_textField.defaultTextFormat = _textFormat;
			}
		}

		/**
		 * Sets the width and height so that it ideally encapsulates the text
		 */
		public function fitSize():void {
			_textField.x = 0;
			_textField.y = 0;

			width = textWidth + 5;
			height = textHeight + 5;
		}


		/******************************************************************************************************/
		/**                                                                                          EFFECTS  */
		/******************************************************************************************************/

		/**
		 * Adds drop shadow effect
		 * @param distance DropShadow distance
		 * @param angle DropShadow angle
		 * @param color DropShadow color
		 * @param alpha DropShadow alpha
		 * @param blurX DropShadow blurX
		 * @param blurY DropShadow blurY
		 * @param strength DropShadow strength
		 */
		public function setShadow(distance:Number = 1, angle:Number = 45, color:uint = 0, alpha:Number = 1, blurX:Number = 1, blurY:Number = 1, strength:Number = 1):void {
			filters = [new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength)];
		}
	}
}