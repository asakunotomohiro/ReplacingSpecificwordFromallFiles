using Newtonsoft.Json;
using PrimeLibrary.Repositories;

namespace NX_LIB.DomainModels.ValueObjects
{
    public partial class NXCM_AS_INFO_SCOPE
    {
        [JsonProperty(PropertyName = "jobsId")]
        public string JOBS_ID { get; set; }

        [JsonProperty(PropertyName = "infoId")]
        public string INFO_ID { get; set; }

        [JsonProperty(PropertyName = "infoSeq")]
        public string INFO_SEQ { get; set; }

        [JsonProperty(PropertyName = "infoScopeCls")]
        public string INFO_SCOPE_CLS { get; set; }

        [JsonProperty(PropertyName = "infoGroupCd")]
        public string INFO_GROUP_CD { get; set; }

        [JsonProperty(PropertyName = "infoSuppCd")]
        public string INFO_SUPP_CD { get; set; }

        [JsonProperty(PropertyName = "infoCustCd")]
        public string INFO_CUST_CD { get; set; }

        [JsonProperty(PropertyName = "infoAreaCd")]
        public string INFO_AREA_CD { get; set; }

        [JsonProperty(PropertyName = "infoBsnsCd")]
        public string INFO_BSNS_CD { get; set; }

        [JsonProperty(PropertyName = "fileInsUserCd")]
        public string FILE_INS_USER_CD { get; set; }

        [JsonProperty(PropertyName = "fileInsDate")]
        public DateTime? FILE_INS_DATE { get; set; }

        [JsonProperty(PropertyName = "fileInsPrgId")]
        public string FILE_INS_PRG_ID { get; set; }

        [JsonProperty(PropertyName = "fileUpdUserCd")]
        public string FILE_UPD_USER_CD { get; set; }

        [JsonProperty(PropertyName = "fileUpdDate")]
        public DateTime? FILE_UPD_DATE { get; set; }

        [JsonProperty(PropertyName = "fileUpdPrgId")]
        public string FILE_UPD_PRG_ID { get; set; }

        [JsonProperty(PropertyName = "fileAutoDate")]
        public DateTime? FILE_AUTO_DATE { get; set; }

        [JsonProperty(PropertyName = "fileAutoPrgId")]
        public string FILE_AUTO_PRG_ID { get; set; }
    }
}
