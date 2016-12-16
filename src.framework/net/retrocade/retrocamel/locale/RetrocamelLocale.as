package net.retrocade.retrocamel.locale {
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;

	use namespace retrocamel_int

	public class RetrocamelLocale {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Default Language
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The selected language
		 */
		public static var selected:String;
		/**
		 * The default language
		 */
		private static var _defaultLanguage:String;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Misc
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Code of the default language set or found
		 */
		public static function get defaultLanguage():String {
			return _defaultLanguage;
		}
		/**
		 * An array of all languages
		 */
		private static var _langs:Array;
		/**
		 * An array containing replacement codes
		 */
		private static var _helperReplacements:Array;

		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		/**
		 * Sets a text localization
		 * @param lang Language of the localization
		 * @param key Key for this string
		 * @param text Text to be returned
		 */
		public static function set(lang:String, key:String, text:String):void {
			_langs[lang][key.toLowerCase()] = text;
		}

		/**
		 * Returns a localized version of string lying under given key
		 * @param lang Language to use
		 * @param key Key of the string
		 * @param rest List of string to replace the "%%" characters
		 * @return Localized string
		 */
		public static function get(lang:String, key:String, ...rest):String {
			if (lang == null) {
				lang = _defaultLanguage;
			}

			if (rest && rest[0] is Array) {
				rest = rest[0];
			}

			key = key.toLowerCase();

			_helperReplacements = rest;

			if (_langs[lang][key]) {
				return _langs[lang][key].replace(/%%/g, getTextReplace);
			}

			return "";
		}

		/**
		 * Checks if a given key exists in the chosen language
		 * @param lang Language to use
		 * @param key Key of the string
		 * @return True if the key exists in the language
		 */
		public static function has(lang:String, key:String):Boolean {
			if (lang == null) {
				lang = _defaultLanguage;
			}

			key = key.toLowerCase();

			return _langs[lang][key];
		}

		public static function checkLangAgainstLang(sourceLang:String, checkedLang:String):Array {
			var missing:Array = [];

			for (var key:String in _langs[sourceLang]) {
				if (!has(checkedLang, key)) {
					missing.push(key);
				}
			}

			return missing;
		}

		//noinspection JSUnusedLocalSymbols
		private static function getTextReplace(match:String, index:int, full:String):String {
			if (_helperReplacements && _helperReplacements.length) {
				return _helperReplacements.shift().toString();
			}
			return "%%"
		}

		/**
		 * Initializes the module
		 */
		retrocamel_int static function initialize():void {
			_langs = [];

			for each(var s:String in RetrocamelCore.settings.languages) {
				_langs[s] = new Dictionary();
			}

			detectLanguageCode();
		}

		/**
		 * Retrieves the language code of the user or the browser language setting using JavaScript (if enabled)
		 * @return Language code of the user or the browser language setting
		 */
		retrocamel_int static function detectLanguageCode(def:String = "en"):void {
			if (RetrocamelCore.settings.languages.indexOf(def) == -1) {
				throw new ArgumentError("Default fallback language is not present in the accepted languages list");
			}

			// We don't detect if it was already detected
			if (_defaultLanguage != "" && _defaultLanguage != null) {
				return;
			}

			// Let's try our luck with Capabilities class
			_defaultLanguage = Capabilities.language.toLowerCase().substr(0, 2);

			// The detected language was found in the allowed list
			if (RetrocamelCore.settings.languages.indexOf(_defaultLanguage) != -1) {
				return;
			}

			// If external interface ain't not available we just set the default one matey.
			if (!ExternalInterface.available) {
				_defaultLanguage = def;
				return;
			}

			try {
				_defaultLanguage = String(ExternalInterface.call("(function(){return(navigator.userLanguage);})")).substr(0, 2);

				if (RetrocamelCore.settings.languages.indexOf(_defaultLanguage) != -1) {
					return;
				}


				_defaultLanguage = String(ExternalInterface.call("(function(){return(navigator.systemLanguage);})")).substr(0, 2);

				if (RetrocamelCore.settings.languages.indexOf(_defaultLanguage) != -1) {
					return;
				}


				_defaultLanguage = String(ExternalInterface.call("(function(){return(navigator.language);})")).substr(0, 2);

				if (RetrocamelCore.settings.languages.indexOf(_defaultLanguage) != -1) {
					return;
				}

				_defaultLanguage = def;
			} catch (e:*) {

				_defaultLanguage = def;
			}
		}
	}
}