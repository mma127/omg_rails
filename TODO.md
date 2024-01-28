SquadBuilder
1. Only open the transport drop target when dragging units/squads

Upgrades
1. Squad `pop` and `popWithTransported` isn't consistent. CompanyGridDropTarget is calculating platoon pop with `popWithTransported` but that isn't updated for squad upgrade pop
2. Show enabled upgrades in the Unlocks card
3. Enable upgrade by unit and minimum vet
4. Should Falls have only 1 of fg42, schreck, at rifles, g43? Can fg42 and g43 be unitwide? seems to be priority issues where fg42 over schreck

Redux
1. Fix missing rejectWithValue. See fetchCompanyBonuses for example

BattlePlayer
1. Pass `side` back for the BattlePlayer to create, to avoid relying on `company.faction.side` which may not be correct (ie, mixed teams)

Player
1. Create a separate RulesetPlayer record to encapsulate ruleset specific data like vps current/earned in that ruleset

UI
1. Discord invite icon
2. Leaderboards for company stats
3. Show VPs in player battle cards
4. Mobile MVP
5. Confirmation before deleting company
6. Confirmation before deleting squad

Enhancements
1. Copy paste squad/upgrade combo
2. Holding area for squad cards outside of tabs
3. User preferences model (ie, saving compact status)

PRELAUNCH
Unused Models
* Game
* UnitGame
* UnitModification
* 