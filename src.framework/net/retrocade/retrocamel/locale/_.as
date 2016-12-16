package net.retrocade.retrocamel.locale {
	/**
	 * Retrieves the localization of text in the current language
	 * @param key Key of the string
	 * @param rest List of paramteres to supplement in the string
	 */
	public function _(key:String, ...rest):String {
		var text:String = RetrocamelLocale.get(RetrocamelLocale.selected, key, rest);

		if (text === null || text === "") {
			trace(key + "=???");

			text = RetrocamelLocale.get('en', key, rest);
			if (text == null || text == "")
				return key;
		}

		return text;
	}
}