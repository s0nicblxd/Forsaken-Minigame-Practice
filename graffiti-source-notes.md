# Clean Graffiti

Added Clean Graffiti immediately below Generators in the main menu. All twelve supplied PNGs are embedded in the downloadable HTML, with descriptive originals in assets/graffiti.

Source references: GraffitiBoard, Images, GraffitiClientBinder and the graffiti objective extracted from the supplied place. The practice version uses ten successful sprays per piece, a 200 ms minimum interval, moving targets, progressive 250 ms vertical shrink/fade, a spray-bottle cursor, blue splash effects and 24 green completion particles. The practice layout replaces the original 3D wall.

User-requested differences: 1–3 pieces per round, one point for clearing the entire round, automatic zoom restart, and no separate Leave button. The sun, tall building and cheese grater together receive 99% of selections; the other six share 1%. Designs do not repeat within a round. Original hashed filenames were identified visually; no unverified asset-ID mapping is assumed.

The tutorial hides after the first cleared round and the play area recenters smoothly. Spray and completion audio await the user's recordings.

Validation: all twelve embedded images decode; 10,000 weighted draws verify common frequency and unique designs; browser checks cover rounds of 1, 2 and 3 pieces, pointer input, cooldown and off-target rejection, one-time scoring, automatic restart, narrow-screen fit and cleanup when leaving. Touch input and missing-animation-API behavior are checked separately. Screenshot inspection caught and corrected an SVG rotation-origin issue in the splash target.

Spacing adjustment: pieces now form a compact randomly oriented cluster with slight overlap. Cluster fitting keeps each rotated sprite inside the practice wall without scaling down its artwork.
