using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.IO;
using System.Drawing;
using System.Diagnostics;
using MySql.Data.MySqlClient;

namespace artfinder
{
    public class Program
    {
        public static void Main(string[] args)
        {
            string lastArtwork = string.Empty;
            if (args.GetLength(0) > 0)
            {
                lastArtwork = args[0];
                Console.WriteLine("Start at image {0}", lastArtwork);
            }
            Console.WriteLine("Start artfinder image collection");
            Stopwatch stopWatch = new();
            stopWatch.Start();
            List<ArtFinderImageInformation> artFinderImageInformationList = GetArtFinderImageInformation(lastArtwork);
            Console.WriteLine("retrieved artfinder artwork URLs");
            GetArtFinderImages(artFinderImageInformationList);
            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;
            string elapsedTime = string.Format("{0:00}:{1:00}:{2:00}.{3:00}",
                ts.Hours, ts.Minutes, ts.Seconds,
                ts.Milliseconds / 10);
            Console.WriteLine("RunTime " + elapsedTime);
        }

        private static List<ArtFinderImageInformation> GetArtFinderImageInformation(string lastArtwork)
        {
            List<ArtFinderImageInformation> artFinderImageInformationList = new();

            string cs = @"server=localhost;userid=root;password=root;database=ArtFinder";
            using MySqlConnection con = new(cs);
            con.Open();
            string sql = "select a.artistID, aw.artworkID, air.image_url from artists a inner join artworks aw on a.artistID = aw.artistID inner join artwork_image_retrieval air on aw.artworkID = air.artworkID;";
            using MySqlCommand cmd = new(sql, con);
            using MySqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ArtFinderImageInformation artFinderImageInformation = new()
                {
                    ArtistID = rdr.GetString(0),
                    ArtworkID = rdr.GetString(1),
                    ArtworkURL = rdr.GetString(2)
                };
                if (KeepArtwork(artFinderImageInformation.ArtworkID, lastArtwork))
                {
                    artFinderImageInformationList.Add(artFinderImageInformation);
                }
            }
            return artFinderImageInformationList;
        }

        private static bool KeepArtwork(string candidateArtwork, string lastArtwork)
        {
            return int.TryParse(lastArtwork.Replace("artwork", string.Empty), out int lastArtworkSequence) &&
                int.TryParse(candidateArtwork.Replace("artwork", string.Empty), out int candiateArtworkSequence) &&
                candiateArtworkSequence > lastArtworkSequence;
        }

        private static void GetArtFinderImages(List<ArtFinderImageInformation> artFinderImageInformationList)
        {
            foreach (ArtFinderImageInformation artFinderImageInformation in artFinderImageInformationList)
            {
                GetArt(artFinderImageInformation).Wait();
            }
        }

        private static async Task GetArt(ArtFinderImageInformation artFinderImageInformation)
        {
            string path = string.Format("/Volumes/ART_DATA/artfinder/{0}", artFinderImageInformation.ArtistID);
            _ = Directory.CreateDirectory(path);
            string localFile = string.Format("{0}/{1}.jpg", path, artFinderImageInformation.ArtworkID);
            if (!File.Exists(localFile))
            {
                using HttpClient httpClient = new();
                Console.Write("downloading {0}.", artFinderImageInformation.ArtworkID);
                Uri imageUri = new(artFinderImageInformation.ArtworkURL);
                
                HttpResponseMessage httpResponseMessage = await httpClient.GetAsync(imageUri).ConfigureAwait(false);
                if (httpResponseMessage.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    byte[] imageContent = await httpResponseMessage.Content.ReadAsByteArrayAsync().ConfigureAwait(false);
                    using MemoryStream memoryStream = new(imageContent);
                    Bitmap bitmap = new(memoryStream);
                    Console.Write(".");
                    bitmap.Save(localFile);
                    Console.WriteLine(". done");
                    Task.Delay(500).Wait();
                }
                else
                {
                    Console.WriteLine("... {0}", httpResponseMessage.StatusCode);
                }
            }

        }
    }
}
