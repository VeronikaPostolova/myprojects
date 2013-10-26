﻿using System.Runtime.Serialization;
namespace CadmiumBankApp.Models
{
    [DataContract]
    public class Currency
    {
        [DataMember(Name="id")]
        public int Id { get; set; }

        [DataMember(Name="name")]
        public string Name { get; set; }
    }
}
