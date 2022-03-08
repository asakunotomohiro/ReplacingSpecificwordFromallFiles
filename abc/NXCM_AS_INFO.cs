using Newtonsoft.Json;
using PrimeLibrary.Repositories;

namespace NX_LIB.DomainModels.ValueObjects
{
    public partial class NXCM_AS_INFO
    {
        [JsonProperty(PropertyName = "jobsId")]
        public string JOBS_ID { get; set; }

        [JsonProperty(PropertyName = "infoId")]
        public string INFO_ID { get; set; }

        [JsonProperty(PropertyName = "groupCd")]
        public string GROUP_CD { get; set; }

        [JsonProperty(PropertyName = "intoTitle")]
        public string INTO_TITLE { get; set; }

        [JsonProperty(PropertyName = "infoCls")]
        public string INFO_CLS { get; set; }

        [JsonProperty(PropertyName = "infoContent")]
        public string INFO_CONTENT { get; set; }

        [JsonProperty(PropertyName = "infoStartDate")]
        public DateTime INFO_START_DATE { get; set; }

        [JsonProperty(PropertyName = "infoLimitDate")]
        public DateTime INFO_LIMIT_DATE { get; set; }

        [JsonProperty(PropertyName = "infoShowCls")]
        public string INFO_SHOW_CLS { get; set; }

        [JsonProperty(PropertyName = "infoShowWeek")]
        public string INFO_SHOW_WEEK { get; set; }

        [JsonProperty(PropertyName = "infoShowMonth")]
        public string INFO_SHOW_MONTH { get; set; }

        [JsonProperty(PropertyName = "infoAllFlg")]
        public string INFO_ALL_FLG { get; set; }

        [JsonProperty(PropertyName = "infoDelFlg")]
        public string INFO_DEL_FLG { get; set; }

        [JsonProperty(PropertyName = "infoRemarks")]
        public string INFO_REMARKS { get; set; }

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
