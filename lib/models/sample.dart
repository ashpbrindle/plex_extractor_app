// import 'package:plextractor/models/movie.dart';
// import 'package:plextractor/models/tv_show.dart';

// List<Movie> sampleMovies = [
//   Movie(name: "Elemental", year: "2023", tvdb: "337156"),
//   Movie(name: "Blue Beetle", year: "2023", tvdb: "156176"),
//   Movie(name: "The Nun II", year: "2023", tvdb: "340887"),
// ];
// List<TvShow> sampleTvShows = [
//   TvShow(
//     name: "Adventure Time",
//     seasonsNames: {
//       "Season 01": "221091",
//       "Season 02": "329151",
//     },
//     tvdb: "152831",
//     year: '2010',
//   )
// ];

// var sample = [
//   {"name": "5 Centimeters Per Second (2007)", "tvdb": null, "type": "movie"},
//   {"name": "10 Cloverfield Lane (2016)", "tvdb": null, "type": "movie"},
//   {"name": "127 Hours (2010)", "tvdb": null, "type": "movie"},
//   {"name": "Alien 3 (1992)", "tvdb": null, "type": "movie"},
//   {"name": "Aliens (1986)", "tvdb": null, "type": "movie"},
//   {"name": "Amazing Spider-Man (2012)", "tvdb": null, "type": "movie"},
//   {"name": "Amazing Spider-Man 2 (2014)", "tvdb": null, "type": "movie"},
//   {"name": "Amélie (2001)", "tvdb": null, "type": "movie"},
//   {
//     "name": "The Secret World of Arrietty (2010)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Asteroid City (2023)", "tvdb": null, "type": "movie"},
//   {"name": "Avatar The Way of Water (2022)", "tvdb": null, "type": "movie"},
//   {"name": "Back to the Future (1985)", "tvdb": null, "type": "movie"},
//   {"name": "Back To The Future Part II (1989)", "tvdb": null, "type": "movie"},
//   {"name": "Back to the Future Part III (1990)", "tvdb": null, "type": "movie"},
//   {"name": "Batman Begins (2005)", "tvdb": null, "type": "movie"},
//   {"name": "Batman - The Killing Joke (2016)", "tvdb": null, "type": "movie"},
//   {"name": "Big Hero 6 (2014)", "tvdb": null, "type": "movie"},
//   {"name": "Black Adam (2022)", "tvdb": null, "type": "movie"},
//   {"name": "Blade Runner 2049 (2017)", "tvdb": null, "type": "movie"},
//   {"name": "Blade Runner (1982)", "tvdb": null, "type": "movie"},
//   {"name": "Boruto - Naruto the Movie (2015)", "tvdb": null, "type": "movie"},
//   {"name": "The Bourne Identity (2002)", "tvdb": null, "type": "movie"},
//   {"name": "Brave (2012)", "tvdb": null, "type": "movie"},
//   {"name": "A Bug's Life (1998)", "tvdb": null, "type": "movie"},
//   {"name": "Cars (2006)", "tvdb": null, "type": "movie"},
//   {"name": "Cars 2 (2011)", "tvdb": null, "type": "movie"},
//   {"name": "Cars 3 (2017)", "tvdb": null, "type": "movie"},
//   {"name": "Cocaine Bear (2023)", "tvdb": null, "type": "movie"},
//   {"name": "Coco (2017)", "tvdb": null, "type": "movie"},
//   {"name": "The Courier (2021)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Dawn of the Planet of the Apes (2014)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "The Day After Tomorrow (2004)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Kimetsu no Yaiba - Mugen ressha-hen (2020)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Django Unchained (2012)", "tvdb": null, "type": "movie"},
//   {"name": "Don't Breathe (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Elvis (2022)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Escape Room Tournament of Champions (2021)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Ex Machina (2015)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Fantastic Beasts and Where to Find Them (2016)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Fantastic Beasts - The Crimes Of Grindelwald (2018)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Fantastic Beasts - The Secrets Of Dumbledore (2022)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Fantastic Mr Fox (2009)", "tvdb": null, "type": "movie"},
//   {"name": "F9 (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Finding Dory (2016)", "tvdb": null, "type": "movie"},
//   {"name": "Finding Nemo (2003)", "tvdb": null, "type": "movie"},
//   {"name": "Four Lions (2010)", "tvdb": null, "type": "movie"},
//   {"name": "Free Guy (2021).MP4", "tvdb": null, "type": "movie"},
//   {"name": "From Up on Poppy Hill (2011)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Ghost in the Shell (2017) {tvdb-535}",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "The Girl Who Leapt Through Time (2006)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Godzilla vs Kong (2021) {tvdb-40752}",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "The Good Dinosaur (2015)", "tvdb": null, "type": "movie"},
//   {"name": "Hacksaw Ridge (2016)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Harry Potter And The Chamber Of Secrets (2002)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter And The Deathly Hallows Part 1 (2010)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter And The Deathly Hallows Part 2 (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter And The Goblet Of Fire (2005)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter and the Half Blood Prince (2009)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter And The Order Of The Phoenix (2007)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter And The Sorcerers Stone (2001)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Harry Potter And The Prisoner Of Azkaban (2004)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Hellboy (2004)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Hellboy II - The Golden Army (2008)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Hitchhikers Guide To The Galaxy (2005)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "The Hitman's Wife's Bodyguard (2021)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "The Hobbit - An Unexpected Journey (2012)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "The Hobbit - The Battle Of The Five Armies (2014)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "The Hobbit - The Desolation Of Smaug (2013)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Honest Thief (2021)", "tvdb": null, "type": "movie"},
//   {"name": "How To Train Your Dragon (2010)", "tvdb": null, "type": "movie"},
//   {"name": "How To Train Your Dragon 2 (2014)", "tvdb": null, "type": "movie"},
//   {
//     "name": "How To Train Your Dragon- The Hidden World (2019)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "The Hunger Games (2012)", "tvdb": null, "type": "movie"},
//   {
//     "name": "The Hunger Games - Catching Fire (2013)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Hunger Games - Mockingjay Part 2 (2015)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "I Want To Eat Your Pancreas (2018)", "tvdb": null, "type": "movie"},
//   {"name": "Iblard Jikan (2007)", "tvdb": null, "type": "movie"},
//   {"name": "THE IMITATION GAME (2014)", "tvdb": null, "type": "movie"},
//   {"name": "Inception (2010)", "tvdb": null, "type": "movie"},
//   {"name": "The Incredibles (2004)", "tvdb": null, "type": "movie"},
//   {"name": "Incredibles 2 (2018)", "tvdb": null, "type": "movie"},
//   {"name": "Independence Day (1996)", "tvdb": null, "type": "movie"},
//   {"name": "Inside Out (2015)", "tvdb": null, "type": "movie"},
//   {"name": "Insidious (2010)", "tvdb": null, "type": "movie"},
//   {"name": "Jason Bourne (2016)", "tvdb": null, "type": "movie"},
//   {"name": "John Wick (2014)", "tvdb": null, "type": "movie"},
//   {"name": "John Wick 2 (2017)", "tvdb": null, "type": "movie"},
//   {"name": "John Wick 3 - Parabellum (2019)", "tvdb": null, "type": "movie"},
//   {"name": "Joker (2019)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Josee to Tora to Sakana-tachi (2020)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Children Who Chase Lost Voices (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Jungle Cruise (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Kill Bill Vol.1 (2003)", "tvdb": null, "type": "movie"},
//   {"name": "Kill Bill Vol.2 (2004)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Kingsman - The Secret Service (2014)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "The Last - Naruto the Movie (2014)", "tvdb": null, "type": "movie"},
//   {"name": "Lilo and Stitch (2002)", "tvdb": null, "type": "movie"},
//   {"name": "Lilo and Stitch 2 (2005)", "tvdb": null, "type": "movie"},
//   {
//     "name": "The Lord Of The Rings - The Return Of The King (2003)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "The Lord Of The Rings - The Two Towers (2002)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Luca (2021)", "tvdb": null, "type": "movie"},
//   {"name": "M3gan (2023)", "tvdb": null, "type": "movie"},
//   {"name": "Mad Max- Fury Road (2015)", "tvdb": null, "type": "movie"},
//   {"name": "Malignant (2021)", "tvdb": null, "type": "movie"},
//   {"name": "A Man Called Otto (2022)", "tvdb": null, "type": "movie"},
//   {"name": "The Martian (2015)", "tvdb": null, "type": "movie"},
//   {"name": "The Matrix Reloaded (2003)", "tvdb": null, "type": "movie"},
//   {"name": "Mission Impossible 2 (2000)", "tvdb": null, "type": "movie"},
//   {"name": "Moana (2016)", "tvdb": null, "type": "movie"},
//   {"name": "Monsters University (2013)", "tvdb": null, "type": "movie"},
//   {"name": "Monsters, Inc.(2001)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Naruto Shippuden the Movie - Blood Prison (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Naruto Shippuden the Movie - The Lost Tower (2010)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Naruto Shippuden the Movie (2007)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Naruto Shippuden the Movie - Bonds (2008)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Naruto Shippuden the Movie - The Will of Fire (2009)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Naruto the Movie - Legend of the Stone of Gelel (2005)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name":
//         "Naruto The Movie 3 - Guardians of the Crescent Moon Kingdom (2006)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Naruto the Movie - Ninja Clash in the Land of Snow (2004)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Nightcrawler (2014)", "tvdb": null, "type": "movie"},
//   {"name": "Ocean Waves (1993)", "tvdb": null, "type": "movie"},
//   {"name": "Onward (2020)", "tvdb": null, "type": "movie"},
//   {"name": "Paranormal Activity 2 (2010)", "tvdb": null, "type": "movie"},
//   {"name": "Paranormal Activity 3 (2011)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Pirates of the Caribbean - Dead Mans Chest (2006)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pirates of the Caribbean - On Stranger Tides (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 3 Spell Of The Unknown (2000)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 4 Celebi - Voice of the Forest (2001)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Pokémon Movie 5 Heroes (2002)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Pokémon Movie 14 Victini and the Black Hero Zekrom (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 14 Victini and the White Hero Reshiram (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 9 Pokémon Ranger and the Temple of the Sea (2006)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 7 Destiny Deoxys (2004)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 17 Diancie and the Cocoon of Destruction (2014)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 16 Genesect and the Legend Awakened (2013)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon the Movie Hoopa and the Clash of Ages (2015)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 20 I Choose You (2017)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 15 Kyurem vs. the Sword of Justice (2012)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 19 Volcanion and the Mechanical Marvel (2016)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Arceus and the Jewel of Life (2009)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 11 Giratina and the Sky Warrior (2008)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 6 Jirachi Wish Maker (2003)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 8 Lucario and the Mystery of Mew (2005)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 1 Mewtwo Strikes Back (1998)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 2 The Power of One (1999)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 10 The Rise of Darkrai (2007)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Pokémon Movie 13 Zoroark - Master of Illusions (2010)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Prisoners (2013)", "tvdb": null, "type": "movie"},
//   {"name": "A Quiet Place Part 2 (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Randy Feltface - Purple Privilege", "tvdb": null, "type": "movie"},
//   {"name": "Randy is Sober (2011)", "tvdb": null, "type": "movie"},
//   {"name": "Randy Writes a Novel (2018)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Sammy J And Randy In Bin Night (2013)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Randy Feltface - The Book of Randicus (2021)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Ratatouille (2007) ", "tvdb": null, "type": "movie"},
//   {"name": "Reservior Dogs (1992)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Rise of the Planet of the Apes (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Road to Ninja Naruto the Movie (2012)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Scott Pilgrim vs the World (2010)", "tvdb": null, "type": "movie"},
//   {"name": "Scream (2022)", "tvdb": null, "type": "movie"},
//   {"name": "A Silent Voice (2016)", "tvdb": null, "type": "movie"},
//   {"name": "Sinister (2012)", "tvdb": null, "type": "movie"},
//   {"name": "Snake Eyes (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Someone's Gaze (2013)", "tvdb": null, "type": "movie"},
//   {"name": "Soul (2020)", "tvdb": null, "type": "movie"},
//   {"name": "Space Jam - A New Legacy (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Spider-Man (2002)", "tvdb": null, "type": "movie"},
//   {"name": "Spider-Man 2 (2004)", "tvdb": null, "type": "movie"},
//   {"name": "Spider-Man 3 (2007)", "tvdb": null, "type": "movie"},
//   {"name": "Star Trek (2009)", "tvdb": null, "type": "movie"},
//   {"name": "Star Trek Beyond (2016)", "tvdb": null, "type": "movie"},
//   {"name": "Star Trek Into Darkness (2013)", "tvdb": null, "type": "movie"},
//   {"name": "Stillwater (2021)", "tvdb": null, "type": "movie"},
//   {"name": "The Suicide Squad (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Suzume (2023)", "tvdb": null, "type": "movie"},
//   {"name": "Tales from Earthsea (2006)", "tvdb": null, "type": "movie"},
//   {"name": "Till Death (2021)", "tvdb": null, "type": "movie"},
//   {"name": "Top Gun Maverek (2022)", "tvdb": null, "type": "movie"},
//   {"name": "Toy Story (1995)", "tvdb": null, "type": "movie"},
//   {"name": "Toy Story 2 (1999)", "tvdb": null, "type": "movie"},
//   {"name": "Toy Story 3 (2010)", "tvdb": null, "type": "movie"},
//   {"name": "Toy Story 4 (2019)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Transformers Age of Extinction (2014)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {
//     "name": "Transformers Dark of the Moon (2011)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Up (2009)", "tvdb": null, "type": "movie"},
//   {
//     "name": "Wallace and Gromit - a Matter of Loaf and Death (2008)",
//     "tvdb": null,
//     "type": "movie"
//   },
//   {"name": "Wall•E (2008)", "tvdb": null, "type": "movie"},
//   {"name": "Weathering with You (2019)", "tvdb": null, "type": "movie"},
//   {"name": "The Whale (2022)", "tvdb": null, "type": "movie"},
//   {"name": "The Wolf of Wall Street (2013)", "tvdb": null, "type": "movie"},
//   {"name": "The Woman in Black (2012)", "tvdb": null, "type": "movie"},
//   {"name": "The Woman King (2022)", "tvdb": null, "type": "movie"},
//   {"name": "Wonder Women 1984 (2021)", "tvdb": null, "type": "movie"},
//   {"name": "X-Men- First Class (2011)", "tvdb": null, "type": "movie"},
//   {"name": "Zack Snyder's Justice League (2021)", "tvdb": null, "type": "movie"}
// ];
