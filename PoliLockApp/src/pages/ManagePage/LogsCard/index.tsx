import React from "react";
import {
  IonButton,
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
  IonIcon,
  IonInput,
  IonItem,
  IonSpinner,
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
  const [loadingSupa, setLoadingSupa] = useState<boolean>(false);
  const [logs, setLogs] = useState<any>();
  const { publish } = useMqtt();

  const {
    handleSubmit,
    register,
    formState: { errors },
  } = useForm();

  const refreshLogs = async () => {
    setLoadingSupa(true);
    try {
      const response = await supabase
        ?.from("logs")
        .select()
        .order("date", { ascending: false })
        .limit(30);

      const data = response?.data;
      setLogs(data);
    } catch {
      alert(
        "Não foi possível carregar os logs. Verifique sua conexão com a internet"
      );
    } finally {
      setLoadingSupa(false);
    }
  };

  useEffect(() => {
    const supabase = createClient(SUPABASE_URL, SUPABASE_API_KEY);
    setSupabase(supabase);
  }, []);

  useEffect(() => {
    refreshLogs();
    const intervalId = setInterval(refreshLogs, 5000);

    return () => clearInterval(intervalId);
  }, [supabase]);

  const logsTopic = getMqttTopic("logs");

  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    publish(logsTopic, data.log);
  };

  return (
    <IonCard>
      <IonCardHeader>
        <IonCardTitle className={styles.title}>
          Monitoramento
          {loadingSupa ? (
            <IonItem>
              <IonSpinner name="dots"></IonSpinner>
            </IonItem>
          ) : (
            ""
          )}
        </IonCardTitle>
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

      <form onSubmit={handleSubmit(onSubmit)}>
        <div className={styles.input}>
          <IonInput {...register("log")} placeholder="Log aqui" />
        </div>
        <IonButton className="ion-margin-top" type="submit" expand="full">
          Publicar LOG
        </IonButton>
      </form>
    </IonCard>
  );
};

export default LogsCard;
