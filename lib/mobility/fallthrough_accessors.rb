# frozen-string-literal: true

module Mobility
=begin

Defines +method_missing+ and +respond_to_missing?+ methods for a set of
attributes such that a method call using a locale accessor, like:

  article.title_pt_br

will return the value of +article.title+ with the locale set to +pt-BR+ around
the method call. The class is called "FallthroughAccessors" because when
included in a model class, locale-specific methods will be available even if
not explicitly defined with the +locale_accessors+ option.

This is a less efficient (but more open-ended) implementation of locale
accessors, for use in cases where the locales to be used are not known when the
model class is generated.

@example Using fallthrough locales on a plain old ruby class
  class Post
    def title
      "title in #{Mobility.locale}"
    end
    include Mobility::FallthroughAccessors.new("title")
  end

  Mobility.locale = :en
  post = Post.new
  post.title
  #=> "title in en"
  post.title_fr
  #=> "title in fr"

=end
  class FallthroughAccessors < MethodFound::Interceptor
    # @param [String] One or more attributes
    def initialize(*attributes)
      super /\A(#{attributes.join('|'.freeze)})_([a-z]{2}(_[a-z]{2})?)(=?|\??)\z/.freeze do |_method_name, matches, *arguments|
        attribute = matches[1].to_sym
        locale, suffix = matches[2].split('_'.freeze)
        locale = "#{locale}-#{suffix.upcase}".freeze if suffix
        Mobility.with_locale(locale) { public_send("#{attribute}#{matches[4]}".freeze, *arguments) }
      end
    end
  end
end
