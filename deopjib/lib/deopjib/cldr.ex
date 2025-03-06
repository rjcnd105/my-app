defmodule Deopjib.Cldr do
  use Cldr,
    locales: ["en", "ko"],
    default_locale: "ko",
    gettext: DeopjibWeb.Gettext,
    providers: [Cldr.Number]
end
