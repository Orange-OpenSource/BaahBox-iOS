#!/bin/sh

#  Baah Box
#
#  Copyright (C) 2017 – 2019 Orange SA
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.

# Run the program at TOOL_PATH to check recursively if source files in TARGET_FOLDER 
# have HEADER_TEMPLATE. Ignore fire IGNORE lines and do not process files in EXCLUSIONS
# https://github.com/Orange-OpenSource/Swift-SourcesHeaderChecker


TOOL_PATH="../tools/check-headers.sh"
TARGET_FOLDER="."
HEADER_TEMPLATE="../tools/.header-template.txt"
IGNORE=2
EXCLUSIONS="../tools/.excluding-list.txt"

$TOOL_PATH --folder "$TARGET_FOLDER" --header "$HEADER_TEMPLATE" --ignoring "$IGNORE" --excluding "$EXCLUSIONS"
result=$?

if [ $result -eq 2 ]
then
	echo "✅ All source files contain legal notice."
	exit 0
else
	echo "🔴 Something wrong occured, see logs for further details."
	exit 1
fi