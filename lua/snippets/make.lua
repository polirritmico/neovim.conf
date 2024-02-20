--- Makefile Snippets
return {
  s(
    {
      trig = "layout",
      name = "My layout for Makefiles",
      dscr = "A complete basic functional layout",
    },
    fmt(
      [[
        SHELL = /bin/bash

        SOURCE_SCRIPT_NAME = {}

        TARGET_FOLDER_INSTALLATION = {}
        TARGET_SCRIPT_NAME = {}

        # Style codes
        GREEN = \033[0;32m
        NS = \033[0m
        DONE = $(GREEN)Done

        # =====================================================

        default:
        	@echo -e "Use 'make install' to copy $(TARGET_SCRIPT_NAME) into $(TARGET_FOLDER_INSTALLATION)"

        install:
        	@echo "Installing '$(SOURCE_SCRIPT_NAME)' into '$(TARGET_FOLDER_INSTALLATION)/'..."
        	@chmod +x $(SOURCE_SCRIPT_NAME)
        	cp $(SOURCE_SCRIPT_NAME) $(TARGET_FOLDER_INSTALLATION)/$(TARGET_SCRIPT_NAME)
        	@echo -e "$(DONE)$(NS)"

        version:
        	@echo "Updating subversion..."
        	@sed -ri 's/(SCRIPT_VERSION=)\\"([0-9])\\.(.*)\\"/echo "\\1\\\\"\\2.$$((\\3+1))\\\\""/ge' $(SOURCE_SCRIPT_NAME)
        	@sed -nr 's/SCRIPT_VERSION="([0-9]\\..*)"/Updated to version: \\1/p' $(SOURCE_SCRIPT_NAME)
        	@echo -e "$(DONE)$(NS)"

        ]],
      {
        i(1, "filename"),
        c(2, { t("/usr/local/bin"), t("$(HOME)/.local/bin"), i(1, "") }),
        c(3, { rep(1), i(3) }),
      }
    )
  ),
}
