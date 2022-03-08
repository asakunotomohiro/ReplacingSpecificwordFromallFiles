using Newtonsoft.Json;
using PrimeLibrary.Repositories;

namespace NX_LIB.DomainModels.ValueObjects

    public partial class NXCM_AS_ALT
    {
        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_ID { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_BASE_ID { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string JOBS_ID { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string GROUP_CD { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string PO_NO { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_CLS { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_RESEND_FLG { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_ESCA_FLG { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_TO_CLS { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_READ_FLG { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_CMP_FLG { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_USER_CD { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public DateTime ALT_SEND_DATE { get; set; }

        [JsonProperty(PropertyName = "xxxxx")]
        public string ALT_MAIL_FLG { get; set; }
    }
}
