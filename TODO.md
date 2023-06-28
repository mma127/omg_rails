SquadBuilder
1. Fix company grid highlighting for transport squads when dragging
2. Fix double tooltips appearing when hovering over transported squad card
3. Only open the transport drop target when dragging units/squads

Upgrades
1. Squad `pop` and `popWithTransported` isn't consistent. CompanyGridDropTarget is calculating platoon pop with `popWithTransported` but that isn't updated for squad upgrade pop
1. Enable upgrade by unit and minimum vet