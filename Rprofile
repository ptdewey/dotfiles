# My standard R configuration
library(styler)

options(languageserver.server_capabilities = list())

# create_style_guide(
#     initialize = default_style_guide_attributes,
#     strict = TRUE
#     # space = NULL,
#     # token = NULL,
#     # line_break = NULL,
# )


options(languageserver.formatting_style = function(options) {
    styler::tidyverse_style(scope = "indentation", indent_by = options$tabSize)
    styler::tidyverse_style(scope = "token", fix_quotes = NULL)
})

