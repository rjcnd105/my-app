defmodule Deopjib.Cldr do
  use Cldr,
    otp_app: :deopjib,
    locales: ["en", "ko"],
    default_locale: "ko",
    gettext: DeopjibWeb.Gettext,
    providers: [Cldr.Number]
end
