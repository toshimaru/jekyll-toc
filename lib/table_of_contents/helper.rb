# frozen_string_literal: true

module Jekyll
  module TableOfContents
    # helper methods for Parser
    module Helper
      PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u.freeze

      def generate_toc_id(text)
        text = text.downcase
                   .gsub(PUNCTUATION_REGEXP, '') # remove punctuation
                   .tr(' ', '-') # replace spaces with dash
        CGI.escape(text)
      end
    end
  end
end
