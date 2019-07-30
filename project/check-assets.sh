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

# Run the program at TOOL_PATH to check if assets in TARGER contain LEGAL_NOTICE in metadata
# https://github.com/Orange-OpenSource/Swift-AssetsLegalMentionsChecker

LEGAL_NOTICE="Baah Box, (c) Copyright Orange SA 2017-2019, CC-BY-SA 4.0 "
TOOL_PATH="../tools/Swift-AssetsLegalMentionsChecker"
TARGET="."

$TOOL_PATH --folder "$TARGET" --mention "$LEGAL_NOTICE"
result=$?

if [ $result -eq 2 ]
then
	echo "✅ All assets contain legal notice in metadata."
	exit 0
else
	echo "🔴 Something wrong occured, see logs for further details."
	exit 1
fi
