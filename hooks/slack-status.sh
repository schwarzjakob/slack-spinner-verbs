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

# Map the verb's vibe to a fitting emoji. Anything unmatched falls back to the robot.
# All bucket emojis are standard Slack shortcodes, so they render in any workspace.
case "$VERB" in
  # 💃 dance & razzle-dazzle
  Boogieing|"Beboppin'"|Grooving|Shimmying|Jitterbugging|Moonwalking|Sock-hopping|Razzle-dazzling|Razzmatazzing|Twisting|Choreographing|Harmonizing|Vibing)
    EMOJI="dancer" ;;
  # 🍳 cooking
  Baking|Brewing|Blanching|Caramelizing|Cooking|Concocting|Frosting|Garnishing|Julienning|Kneading|Leavening|Marinating|Proofing|Sautéing|Seasoning|Simmering|Stewing|Tempering|Whisking|Zesting|Drizzling|Flambéing|Bunning)
    EMOJI="cooking" ;;
  # 🧠 deep thought
  Cogitating|Cerebrating|Considering|Contemplating|Deliberating|Determining|Deciphering|Elucidating|Ideating|Imagining|Inferring|Mulling|Musing|Pondering|Pontificating|Philosophising|Puzzling|Ruminating|Thinking|Combobulating|Recombobulating)
    EMOJI="brain" ;;
  # 🚀 space & physics
  Orbiting|Hyperspacing|Warping|Levitating|Quantumizing|Ionizing|Nebulizing|Nucleating|Catapulting|Osmosing|Sublimating|Symbioting|Beaming)
    EMOJI="rocket" ;;
  # ✨ magic
  Manifesting|Enchanting|Prestidigitating|Transfiguring|Transmuting|Crystallizing|Metamorphosing|Actualizing)
    EMOJI="sparkles" ;;
  # 🌪️ weather & flow
  Billowing|Misting|Precipitating|Thundering|Gusting|Evaporating|Fluttering|Whirlpooling|Swirling|Undulating|Cascading|Flowing|Ebbing|Whirring|Unfurling)
    EMOJI="tornado" ;;
  # 🌱 growing things
  Sprouting|Germinating|Pollinating|Photosynthesizing|Propagating|Cultivating|Fermenting|Incubating|Hatching|Nesting|Roosting)
    EMOJI="seedling" ;;
  # 🛠️ building & crunching
  Architecting|Bootstrapping|Forging|Forming|Crafting|Creating|Composing|Computing|Calculating|Crunching|Processing|Synthesizing|Reticulating|Generating|Hashing|Wrangling|Gitifying)
    EMOJI="hammer_and_wrench" ;;
  # 🐾 scampering critters
  Scampering|Scurrying|Slithering|Waddling|Galloping|Pouncing|Burrowing|Herding|Spelunking|Booping|Honking)
    EMOJI="feet" ;;
  # 🚶 wandering
  Meandering|Moseying|Wandering|Gallivanting|Perambulating|Frolicking|Skedaddling|Schlepping|Puttering)
    EMOJI="footprints" ;;
  # 🙃 shenanigans
  Befuddling|Bloviating|Boondoggling|Dilly-dallying|Fiddle-faddling|Flibbertigibbeting|Flummoxing|Hullaballooing|Lollygagging|Shenaniganing|Tomfoolering|Whatchamacalliting|Topsy-turvying|Wibbling|Noodling|Doodling|Discombobulating)
    EMOJI="upside_down_face" ;;
  *)
    EMOJI="robot_face" ;;
esac

curl -s -X POST "https://slack.com/api/users.profile.set" \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"profile\":{\"status_text\":\"$VERB...\",\"status_emoji\":\":$EMOJI:\",\"status_expiration\":$(( $(date +%s) + 120 ))}}" \
  > /dev/null 2>&1 &

exit 0
