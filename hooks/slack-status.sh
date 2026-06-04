#!/bin/bash
# Syncs Claude Code's current activity to Slack status.
# Installed by install.sh — do not edit the token here directly; re-run install.sh.

SLACK_TOKEN="__SLACK_TOKEN__"

VERBS=(
  "Accomplishing" "Actioning" "Actualizing" "Architecting" "Baking" "Beaming"
  "Beboppin'" "Befuddling" "Billowing" "Blanching" "Bloviating" "Boogieing"
  "Boondoggling" "Booping" "Bootstrapping" "Brewing" "Bunning" "Burrowing"
  "Calculating" "Canoodling" "Caramelizing" "Cascading" "Catapulting"
  "Cerebrating" "Channeling" "Channelling" "Choreographing" "Churning" "Clauding"
  "Coalescing" "Cogitating" "Combobulating" "Composing" "Computing"
  "Concocting" "Considering" "Contemplating" "Cooking" "Crafting" "Creating"
  "Crunching" "Crystallizing" "Cultivating" "Deciphering" "Deliberating"
  "Determining" "Dilly-dallying" "Discombobulating" "Doing" "Doodling"
  "Drizzling" "Ebbing" "Effecting" "Elucidating" "Embellishing" "Enchanting"
  "Envisioning" "Evaporating" "Fermenting" "Fiddle-faddling" "Finagling"
  "Flambéing" "Flibbertigibbeting" "Flowing" "Flummoxing" "Fluttering"
  "Forging" "Forming" "Frolicking" "Frosting" "Gallivanting" "Galloping"
  "Garnishing" "Generating" "Gesticulating" "Germinating" "Gitifying" "Grooving"
  "Gusting" "Harmonizing" "Hashing" "Hatching" "Herding" "Honking"
  "Hullaballooing" "Hyperspacing" "Ideating" "Imagining" "Improvising"
  "Incubating" "Inferring" "Infusing" "Ionizing" "Jitterbugging" "Julienning"
  "Kneading" "Leavening" "Levitating" "Lollygagging" "Manifesting"
  "Marinating" "Meandering" "Metamorphosing" "Misting" "Moonwalking"
  "Moseying" "Mulling" "Mustering" "Musing" "Nebulizing" "Nesting"
  "Newspapering" "Noodling" "Nucleating" "Orbiting" "Orchestrating" "Osmosing"
  "Perambulating" "Percolating" "Perusing" "Philosophising"
  "Photosynthesizing" "Pollinating" "Pondering" "Pontificating" "Pouncing"
  "Precipitating" "Prestidigitating" "Processing" "Proofing" "Propagating"
  "Puttering" "Puzzling" "Quantumizing" "Razzle-dazzling" "Razzmatazzing"
  "Recombobulating" "Reticulating" "Roosting" "Ruminating" "Sautéing"
  "Scampering" "Schlepping" "Scurrying" "Seasoning" "Shenaniganing"
  "Shimmying" "Simmering" "Skedaddling" "Sketching" "Slithering" "Smooshing"
  "Sock-hopping" "Spelunking" "Spinning" "Sprouting" "Stewing" "Sublimating"
  "Swirling" "Swooping" "Symbioting" "Synthesizing" "Tempering" "Thinking"
  "Thundering" "Tinkering" "Tomfoolering" "Topsy-turvying" "Transfiguring"
  "Transmuting" "Twisting" "Undulating" "Unfurling" "Unravelling" "Vibing"
  "Waddling" "Wandering" "Warping" "Whatchamacalliting" "Whirlpooling"
  "Whirring" "Whisking" "Wibbling" "Working" "Wrangling" "Zesting"
  "Zigzagging"
)

VERB="${VERBS[$((RANDOM % ${#VERBS[@]}))]}"

curl -s -X POST "https://slack.com/api/users.profile.set" \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"profile\":{\"status_text\":\"$VERB...\",\"status_emoji\":\":robot_face:\",\"status_expiration\":$(( $(date +%s) + 120 ))}}" \
  > /dev/null 2>&1 &

exit 0
