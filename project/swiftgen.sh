#!/bin/sh

ROOT=$(dirname "$0")
SWIFTGEN="$PODS_ROOT/SwiftGen/bin/swiftgen"
INDIR="$ROOT/OrangeTrainingBox/Resources"
OUTDIR="$ROOT/OrangeTrainingBox/Resources/CodeGen/Constants"



"$SWIFTGEN" storyboards "$INDIR" -t scenes-swift4 -o "$OUTDIR"/Storyboards.swift
"$SWIFTGEN" xcassets "$INDIR/Assets.xcassets" -t swift4 -o "$OUTDIR"/Assets.swift
"$SWIFTGEN" strings "$INDIR/en.lproj/Localizable.strings" -t structured-swift4 -o "$OUTDIR"/Strings.swift


