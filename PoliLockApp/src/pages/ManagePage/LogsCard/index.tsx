import React from "react";
import {
  IonButton,
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
  IonIcon,
  IonInput,
} from "@ionic/react";

import { useEffect, useState } from "react";
import { SupabaseClient, createClient } from "@supabase/supabase-js";
import { SUPABASE_URL, SUPABASE_API_KEY, getMqttTopic } from "../../../config";

import LogsList from "./LogsList";
import { FieldValues, SubmitHandler, useForm } from "react-hook-form";

import styles from "./LogsCard.module.css";
import { useMqtt } from "../../../contexts/MqttContext";
import { refresh } from "ionicons/icons";

const LogsCard: React.FC = () => {
  const [supabase, setSupabase] = useState<SupabaseClient | undefined>();
  const [logs, setLogs] = useState<any>();
  const { publish } = useMqtt();

  const {
    handleSubmit,
    register,
    formState: { errors },
  } = useForm();

  const refreshLogs = async () => {
    const response = await supabase?.from("logs").select();
    const data = response?.data;
    setLogs(data);
  };

  useEffect(() => {
    const supabase = createClient(SUPABASE_URL, SUPABASE_API_KEY);
    setSupabase(supabase);
    refreshLogs();
  }, []);

  const logsTopic = getMqttTopic("logs");

  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    publish(logsTopic, data.log);
  };

  return (
    <IonCard>
      <IonCardHeader>
        <IonCardTitle>Monitoramento</IonCardTitle>
      </IonCardHeader>

      <LogsList logs={logs} />
      <IonCardContent>
        <IonButton
          className="ion-margin-top"
          type="submit"
          onClick={() => refreshLogs()}
          expand="full"
        >
          <IonIcon slot="start" icon={refresh}></IonIcon>
          Recarregar Logs
        </IonButton>
      </IonCardContent>

      {/* <form onSubmit={handleSubmit(onSubmit)}>
        <div className={styles.input}>
        <IonInput {...register("log")} placeholder="Log aqui" />
        </div>
        <IonButton className="ion-margin-top" type="submit" expand="full">
        Publicar LOG
        </IonButton>
      </form> */}
    </IonCard>
  );
};

export default LogsCard;
